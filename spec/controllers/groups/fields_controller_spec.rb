require 'rails_helper'

RSpec.describe Groups::FieldsController, type: :controller do
  let(:user) { create :user }
  let!(:group) { create(:group, enterprise: user.enterprise) }
  let!(:field) { create(:field, type: 'NumericField', group: group, field_type: 'regular') }


  describe 'GET#time_series' do
    context 'when user is logged in' do
      login_user_from_let

      context 'json format' do
        before {
          get :time_series, group_id: group.id, id: field.id, format: :json
        }

        it 'returns correct data' do
          json_response = JSON.parse(response.body, symbolize_names: true)

          expect(json_response[:highcharts][0][:name]).to eq field.title
        end

        it 'gets the charts in json format' do
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'csv format' do
        before {
          allow(GroupFieldTimeSeriesDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :time_series, group_id: group.id, id: field.id, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(GroupFieldTimeSeriesDownloadJob).to have_received(:perform_later)
        end
      end
    end

    context 'when user is not logged in' do
      before { get :time_series, group_id: group.id, id: field.id, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
