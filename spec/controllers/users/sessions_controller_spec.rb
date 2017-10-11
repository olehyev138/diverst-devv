require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
    let(:enterprise) { create(:enterprise, :has_enabled_saml => true)}
    let(:user){ create(:user, :enterprise => enterprise) }

    before :each do
        session[:saml_for_enterprise] = user.enterprise.id
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    describe "GET#new" do
        it "redirect_to sso_enterprise_saml_index_url" do
            get :new
            expect(response).to redirect_to sso_enterprise_saml_index_url(enterprise_id: enterprise.id)
        end
        
        it "redirect_to sso_enterprise_saml_index_url" do
            enterprise.has_enabled_saml = false
            enterprise.save!
            get :new
            expect(response).to be_success
        end
    end
end