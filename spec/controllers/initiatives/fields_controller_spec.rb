require 'rails_helper'

RSpec.describe Initiatives::FieldsController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:initiative) { initiative_of_group(group) }
  let(:field) { create :field, initiative: initiative, elasticsearch_only: false }
  let(:initiative_field) { create :initiative_field, initiative: initiative, field: field }



  describe 'GET#time_series' do
    describe 'with logged in user' do
      login_user_from_let

      context 'json' do
        before {
          get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json
        }

        it 'gets the time_series' do
          expect(response).to be_success
        end

        it 'return response in json format' do
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'csv' do
        before {
          allow(InitiativeFieldTimeSeriesDownloadJob).to receive(:perform_later)
          request.env['HTTP_REFERER'] = 'back'
          get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :csv
        }

        it 'returns to previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'flashes' do
          expect(flash[:notice]).to eq 'Please check your Secure Downloads section in a couple of minutes'
        end

        it 'calls job' do
          expect(InitiativeFieldTimeSeriesDownloadJob).to have_received(:perform_later)
        end
      end
    end

    describe 'without a logged in user' do
      before { get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
