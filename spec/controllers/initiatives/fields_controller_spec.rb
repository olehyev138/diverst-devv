require 'rails_helper'

RSpec.describe Initiatives::FieldsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:initiative){ initiative_of_group(group) }
    let(:field) {create :field, container_id: initiative.id, container_type: "Initiative", elasticsearch_only: false}
    let(:initiative_field) {create :initiative_field, initiative: initiative, field: field}



    describe 'GET#time_series' do
        describe 'with logged in user' do
            login_user_from_let

            it "gets the time_series" do
                get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json
                expect(response).to be_success
            end

            it "return response in json format" do
                get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json
                expect(response.content_type).to eq 'application/json'
            end

            it 'return response in csv format' do 
                get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :csv 
                expect(response.content_type).to eq 'text/csv'
            end
        end

        describe 'without a logged in user' do
            before { get :time_series, group_id: group.id, initiative_id: initiative.id, id: field.id, format: :json }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end