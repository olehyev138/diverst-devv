require 'rails_helper'

RSpec.describe User::SocialLinksController, type: :controller do
    let(:user){ create(:user) }
    let(:group){ create(:group) }
    let(:social_link) {create(:social_link, :author => user)}
    
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
            before {post :create, social_link: {url: social_link.url}}
            
            it "redirects to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your link was created")
            end
            
            it "creates the link" do
                expect(SocialLink.count).to eq(2)
            end
        end
    end
    
    describe "DELETE#destroy" do
        context "when successful" do
            before {delete :destroy, id: social_link.id}
            
            it "redirects to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "flashes" do
                expect(flash[:notice]).to eq("Your social post was removed")
            end
        end
        
        context "when unsuccessful" do
            before {
                allow_any_instance_of(SocialLink).to receive(:destroy).and_return(false)
                delete :destroy, id: social_link.id
            }
            
            it "redirects to index" do
                expect(response).to redirect_to action: :index
            end
            
            it "flashes" do
                expect(flash[:alert]).to eq("An error occured while deleting your social post")
            end
        end
    end
end