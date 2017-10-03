require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
    let(:user){ create(:user) }

    before :each do
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    
    describe "GET#new" do
        login_user_from_let
        it "returns success" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe "GET#edit" do
        it "returns success" do
            invited = create(:user)
            invited.invite!
            
            get :edit, invitation_token: invited.raw_invitation_token
            expect(response).to be_success
        end
    end
    
    describe "PATCH#update", :skip => "Unsure on how to test" do
        it "returns success" do
            invited = create(:user, enterprise: user.enterprise)
            invited.invite!
            
            patch :update, invitation_token: invited.raw_invitation_token, user: {password: "password"}
            expect(response).to be_success
        end
    end
    
    describe "POST#create" do
        login_user_from_let
        
        it "renders new template" do
            post :create
            expect(response).to render_template :new
        end
    end
end