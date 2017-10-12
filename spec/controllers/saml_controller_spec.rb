require 'rails_helper'

RSpec.describe SamlController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test", idp_sso_target_url: "http://example.com")}
    let(:user) {create(:user, enterprise: enterprise)}
    
    describe "GET#index" do
        it "gets the attrs" do
            get :index, enterprise_id: enterprise.id
            expect(response).to be_success
        end
    end
    
    describe "GET#sso" do
        it "renders no settings" do
            allow_any_instance_of(Enterprise).to receive(:saml_settings).and_return(nil)
            request.env["HTTP_REFERER"] = "back"
            
            get :sso, enterprise_id: enterprise.id
            expect(response).to redirect_to "back"
        end
        
        it "redirects to idp_sso_target_url" do
            get :sso, enterprise_id: enterprise.id
            
            expect(response.code).to eq("302")
            expect(response.location).to include("http://example.com?SAMLRequest=")
        end
    end
    
    describe "POST#acs" do
        it "gets acs" do
            saml = OpenStruct.new({:is_valid? => true, :nameid => user.email, :attributes => {}})
            allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)
            
            get :acs, enterprise_id: enterprise.id, SAMLResponse: "test"
            expect(response).to redirect_to user_root_path
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
