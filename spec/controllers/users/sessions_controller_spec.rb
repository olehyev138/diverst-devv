require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
    let(:user){ create(:user) }

    before :each do
        session[:saml_for_enterprise] = user.enterprise.id
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    describe "GET#new" do
        before {get :new}
        
        it "renders success" do
            expect(response).to be_success
        end
    end
end