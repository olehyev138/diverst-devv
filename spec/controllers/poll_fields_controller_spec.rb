require 'rails_helper'

RSpec.describe PollFieldsController, type: :controller do
    let(:enterprise) {create :enterprise}
    let(:user) { create :user, enterprise: enterprise}
    let(:poll) {create :poll}
    let(:field) {create :field, type: "CheckboxField"}
    
    describe 'GET #answer_popularities' do
        context 'with logged user' do
            login_user_from_let
            
            before { get :answer_popularities, :poll_id => poll.id, :id => field.id}
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'GET #show' do
        context 'with logged user' do
            login_user_from_let
            
            before { get :show, :poll_id => poll.id, :id => field.id}
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
end