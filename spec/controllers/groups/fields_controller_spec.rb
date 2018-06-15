require 'rails_helper'

RSpec.describe Groups::FieldsController, type: :controller do
    let(:user) { create :user }
    let!(:group){ create(:group, enterprise: user.enterprise) }
    let!(:field){create(:field, type: "NumericField", group: group, field_type: "regular")}


    describe 'GET#time_series' do
        context 'when user is logged in' do
            login_user_from_let


            it 'returns correct data in json' do
                get :time_series, group_id: group.id, id: field.id, format: :json
                json_response = JSON.parse(response.body, symbolize_names: true)

                expect(json_response[:highcharts][0][:name]).to eq field.title
            end

            it "gets the charts in json format" do
                get :time_series, group_id: group.id, id: field.id, format: :json
                expect(response.content_type).to eq 'application/json' 
            end

            it "gets the charts in csv format" do
                get :time_series, group_id: group.id, id: field.id, format: :csv
                expect(response.content_type).to eq 'text/csv'
            end

            it 'returns file name in csv format' do 
                get :time_series, group_id: group.id, id: field.id, format: :csv
                expect(response.headers["Content-Disposition"]).to include "metrics#{field.id}.csv"
            end
        end

        context 'when user is not logged in' do
            before { get :time_series, group_id: group.id, id: field.id, format: :json }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
