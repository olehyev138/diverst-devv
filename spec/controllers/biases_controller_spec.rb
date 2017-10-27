require 'rails_helper'

RSpec.describe BiasesController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: enterprise) }
    let(:bias){ create(:bias) }
    
    describe "GET#index" do
        describe "with logged in user" do
            login_user_from_let
            
            it "return success" do
                get :index
                expect(response).to be_success
            end

            it "get the biases" do 
                
            end
        end
    end
    
    describe "GET#new" do
        describe "with logged in user" do
            login_user_from_let
            
            it "gets the biases" do
                get :new
                expect(response).to be_success
            end
        end
    end
    
    describe 'POST#create' do
        context 'with logged user' do
            login_user_from_let
            
            before :each do
                request.env["HTTP_REFERER"] = "back"
            end
            
            context 'with correct params' do
                let(:bias_params) { FactoryGirl.attributes_for(:bias) }
                
                it 'redirects to correct action' do
                    post :create, bias: bias_params
                    expect(response).to redirect_to "back"
                end
                
                it 'creates new bias' do
                    expect{
                    post :create, bias: bias_params
                    }.to change(Bias,:count).by(1)
                end
                
                it "flashes notice" do
                    expect(flash[:notice])
                end
            end
        end
    end
end