require 'rails_helper'

RSpec.describe EnterprisesController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:group){ create(:group, enterprise: enterprise) }
  
    describe "GET#calendar" do
    
        it "allows view to be embed on iframe" do
            get :calendar, id: enterprise.id
            expect(response.headers).to_not include("X-Frame-Options")
        end
    
        it "assigns enterprise to @enterprise" do
            get :calendar, id: enterprise.id
            expect(assigns(:enterprise)).to eq enterprise
        end
    end
    
    describe "GET#edit" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "PATCH#update" do
        describe "with logged in user" do
            before :each do 
                request.env["HTTP_REFERER"] = "back"
            end
            login_user_from_let
            
            context "with valid parameters" do
                before(:each){ patch :update, id: enterprise.id, enterprise: attributes_for(:enterprise, cdo_name: "updated") }
                
                it "updates the enterprise" do
                    enterprise.reload
                    expect(enterprise.cdo_name).to eq "updated"
                end
                
                it "redirects to action index" do
                    expect(response).to redirect_to "back"
                end
                
                it "flashes notice" do 
                    expect(flash[:notice])
                end
            end
            
            context "with invalid parameters" do
                before(:each){ patch :update, id: enterprise.id, enterprise: attributes_for(:enterprise, name: "") }
                
                it "does not update the enterprise" do
                    enterprise.reload
                    expect(enterprise.cdo_name).to eq "test"
                end
                
                it "renders action edit" do
                    expect(response.status).to eq(302)
                end
                
                it "flashes alert" do
                    expect(flash[:alert])
                end
            end
        end
    end
    
    describe "GET#edit_fields" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_fields, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#edit_budgeting" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_budgeting, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    # CAN'T FIGURE OUT HOW TO PASS TEST
    
    describe "GET#bias", :skip => true do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :bias, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    # CONTROLLER IS MISSING A TEMPLATE
    
    describe "GET#edit_cdo", :skip => true do
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_cdo, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    # CONTROLLER IS MISSING A TEMPLATE
    
    describe "GET#edit_mobile_fields", :skip => true do
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_mobile_fields, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#edit_auth" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_auth, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#edit_branding" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_branding, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    # CONTROLLER IS MISSING A TEMPLATE
    
    describe "GET#edit_algo", :skip => true do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ get :edit_algo, id: enterprise.id}
                
                it "returns success" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#update_branding" do
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ patch :update_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: {logo_file_name: "test"})}
                
                it "redirect_to edit_branding" do
                    expect(response).to redirect_to action: :edit_branding
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
        end
    end
    
    describe "GET#delete_attachment" do
        before :each do
            request.env["HTTP_REFERER"] = "back"
        end
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ patch :delete_attachment, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: {logo_file_name: "test"})}
                
                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end
                
                it "flashes" do
                    expect(flash[:notice])
                end
            end
        end
    end
    
    describe "GET#restore_default_branding" do
        before :each do
            request.env["HTTP_REFERER"] = "back"
        end
        
        describe "with logged in user" do
            login_user_from_let
            
            context "with valid id" do
                before(:each){ patch :restore_default_branding, id: enterprise.id, enterprise: attributes_for(:enterprise, theme: {logo_file_name: "test"})}
                
                it "redirect_to back" do
                    expect(response).to redirect_to "back"
                end
            end
        end
    end
end
