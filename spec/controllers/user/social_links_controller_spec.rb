require 'rails_helper'

RSpec.describe User::SocialLinksController, type: :controller do
    let(:user){ create(:user) }
    
    login_user_from_let
    
    describe "GET#index" do
        it "returns success" do
            get :index
            expect(response).to be_success
        end
    end
    
    describe "GET#new" do
        it "returns success" do
            get :new
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        context "when invalid params" do
            before {post :create, social_link: {url: "fakeurl.com"}}
            
            it "redirects to new" do
                expect(response).to render_template :new
            end
            
            it "flashes" do
                expect(flash[:alert]).to eq("Your link was not created. Please fix the errors")
            end
        end
        
        context "when valid params" do
            before {post :create, social_link: {url: "http://www.youtube.com/watch?v=2BYXBC8WQ5k"}}
            
            it "redirects to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your link was created")
            end
            
            it "creates the link" do
                expect(SocialLink.count).to eq(1)
            end
        end
    end
end