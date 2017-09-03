require 'rails_helper'

RSpec.describe SamlController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
  
    describe "GET#index" do
        it "gets the attrs" do
            get :index, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "GET#sso" do
        it "renders no settings", :skip => "Missing template" do
            allow_any_instance_of(Enterprise).to receive(:saml_settings).and_return(nil)
            get :sso, enterprise_id: enterprise.id
            expect(response).to redirect_to action: :no_settings
        end
        
        it "renders no settings", :skip => "Unsure on how to test" do
            get :sso, enterprise_id: enterprise.id
        end
    end
    
    describe "POST#acs", :skip => "Unsure on how to test" do
        it "gets acs" do
            get :acs, enterprise_id: enterprise.id
        end
    end
    
    describe "GET#metadata" do
        it "gets metadata" do
            get :metadata, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "GET#logout" do
        it "gets SAMLRequest logout", :skip => "Unsure on how to test" do
            get :logout, enterprise_id: enterprise.id, SAMLRequest: ""
            expect(response).to be_success
        end
        
        it "gets SAMLRequest logout" do
            get :logout, enterprise_id: enterprise.id, slo: ""
            expect(response).to be_success
        end
        
        it "gets regular logout" do
            get :logout, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
end
