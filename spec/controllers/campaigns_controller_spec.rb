require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:campaign){ create(:campaign, enterprise: enterprise) }
    
    
    describe 'GET#index' do
        context 'with logged user' do
            login_user_from_let
            
            before { get :index}
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'GET#new' do
        context 'with logged user' do
            login_user_from_let
            
            before { get :new }
            
            it 'return success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'POST#create' do
        context 'with logged user' do
            login_user_from_let
            
            context 'with correct params' do
                let(:campaign_params) { FactoryGirl.attributes_for(:campaign) }
                
                it 'redirects to correct action' do
                    post :create, campaign: campaign_params
                    expect(response).to redirect_to action: :index
                end
                
                it 'creates new budget' do
                    expect{
                    post :create, campaign: campaign_params
                    }.to change(Campaign,:count).by(1)
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
            
            context 'with incorrect params' do
                it 'raises an error' do
                    bypass_rescue
                    expect{ post :create, campaign: {}}.to raise_error ActionController::ParameterMissing
                end
            end
        end
    end
    
    describe "GET#show" do
        describe "with logged in user" do
            login_user_from_let
            
            it "gets the campaign" do
                get :show, id: campaign.id
                expect(response).to be_success
            end
            
            it "doesn't get the campaign" do
                bypass_rescue
                expect{ get :show, id: -1}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
    
    describe "GET#edit" do
        describe "with logged in user" do
            login_user_from_let
            
            it "gets the campaign" do
                get :edit, id: campaign.id
                expect(response).to be_success
            end
            
            it "doesn't get the campaign" do
                bypass_rescue
                expect{ get :edit, id: -1}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
    
    describe "PATCH#update" do
        describe "with logged in user" do
            login_user_from_let
            
            it "updates the campaign" do
                patch :update, id: campaign.id,  campaign: attributes_for(:campaign, title: "updated")
                campaign.reload
                expect(campaign.title).to eq("updated")
            end
        end
    end

    describe "DELETE#destroy" do
        describe "with logged in user" do

            login_user_from_let
            
            it "destroy the campaign" do
                delete :destroy, id: campaign.id
                expect(response).to redirect_to action: :index
            end
        end
    end
    
    describe "GET#contributions_per_erg" do
        context "with logged in user" do
            login_user_from_let
            
            it "gets the contributions_per_erg with json" do
                get :contributions_per_erg, id: campaign.id, format: :json
            end
            
            it "gets the contributions_per_erg with csv" do
                get :contributions_per_erg, id: campaign.id, format: :csv
            end
            
            it "doesn't get the contributions_per_erg" do
                bypass_rescue
                expect{ get :contributions_per_erg, id: -1}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
    
    describe "GET#top_performers" do
        context "with logged in user" do
            login_user_from_let
            
            it "gets the top_performers with json" do
                get :top_performers, id: campaign.id, format: :json
            end
            
            it "gets the top_performers with csv" do
                get :top_performers, id: campaign.id, format: :csv
            end
            
            it "doesn't get the top_performers" do
                bypass_rescue
                expect{ get :top_performers, id: -1}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
end