require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:policy_group){ create(:policy_group, enterprise: enterprise, default_for_enterprise: true)}

    login_user_from_let

    before{ policy_group.save }

    describe "GET#index" do
        it "returns success" do
            get :index, :id => user.id
            expect(response).to be_success
        end

        it "returns an html response" do 
            get :index, :id => user.id
            expect(response.content_type).to eq "text/html"
        end

        it "returns a json response" do 
            get :index, :id => user.id , format: :json
            expect(response.content_type).to eq "application/json"
        end

        it "returns 2 UserDatatable objects in json" do 
            create(:user, enterprise: enterprise) 
            get :index, :id => user.id, format: :json
            json_response = JSON.parse(response.body, symbolize_names: true)
            expect(json_response[:recordsTotal]).to eq 2
        end

        it "returns users" do 
            get :index, :id => user.id
            expect(assigns[:users]).to eq [user]
        end
    end


    describe "GET#sent_invitations" do
        it "returns a json response" do 
            get :sent_invitations, :format => :json 
            expect(response.content_type).to eq "application/json"
        end
    end


    describe "GET#saml_logins" do
        it "returns success" do
            get :saml_logins, :format => :json
            expect(response).to be_success
        end

        it "returns users" do
            create(:user, enterprise: enterprise, auth_source: "saml")
            get :saml_logins
            expect(assigns[:users].count).to eq 1
        end

         it "returns a new UserDatatable object in json" do 
            create(:user, enterprise: enterprise, auth_source: "saml") 
            get :saml_logins, :format => :json
            json_response = JSON.parse(response.body, symbolize_names: true)
            expect(json_response[:recordsTotal]).to eq 1
        end
    end


    describe "GET#new", :skip => "Missing template" do
        it "returns success" do
            get :new
            expect(response).to be_success
        end
    end


    describe "GET#show" do
        before { get :show, :id => user.id  }
        it "returns success" do
            expect(response).to be_success
        end

        it "render show template" do 
            expect(response).to render_template :show 
        end

        it "returns a valid user" do 
            expect(assigns[:user]).to be_valid
        end
    end
    

    describe "GET#group_surveys" do
       before { 2.times { create(:group, enterprise: enterprise) } }

        it "returns success" do
            get :group_surveys, :id => user.id
            expect(response).to be_success
        end

        it "returns manageable group ids" do 
            manageable_group_ids = [Group.first.id, Group.last.id]
            get :group_surveys, :id => user.id 
            expect(assigns[:user].enterprise.group_ids).to eq manageable_group_ids
        end

        it "returns user groups" do 
            manageable_group_ids = [Group.first.id, Group.last.id]
            2.times { create(:user_group, user: user, group_id: manageable_group_ids, data: nil) }
            get :group_surveys, :id => user.id
            expect(assigns[:user].user_groups.count).to eq 2
        end
    end

    describe "GET#edit" do
        it "render template" do
            get :edit, :id => user.id
            expect(response).to render_template :edit
        end

        it "returns a valid user object" do 
            get :edit, :id => user.id 
            expect(assigns[:user]).to be_valid
        end
    end


    describe "PATCH#update" do
        context "for a successful update" do 
            before { patch :update, :id => user.id, :user => {:first_name => "updated"} }

            it "redirects to user" do
                expect(response).to redirect_to(user)
            end

            it "updates the user" do
                user.reload
                expect(user.first_name).to eq("updated")
            end

            it "flashes a notice message" do
                expect(flash[:notice]).to eq "Your user was updated"
            end
        end

        context "for an unsuccessful update" do 
            before { patch :update, :id => user.id, :user => { :email => "bademail" } }

            it "flashes an alert message" do 
                expect(flash[:alert]).to eq "Your user was not updated. Please fix the errors"
            end

            it "render edit template" do 
                expect(response).to render_template :edit
            end
        end
    end


    describe "delete#destroy" do
        before do
            request.env["HTTP_REFERER"] = "back"
            delete :destroy, :id => user.id
        end

        it "redirects to previous url" do
            expect(response).to redirect_to "back"
        end

        it "deletes the user" do
            expect(User.where(:id => user.id).count).to eq(0)
        end
    end

    
    describe "PATCH#resend_invitation" do
        before do
            request.env["HTTP_REFERER"] = "back"
            patch :resend_invitation, :id => user.id
        end
        
        it "redirects to back" do
            expect(response).to redirect_to "back"
        end

        it "updates the user invitation_sent_at" do
            user.reload
            expect(user.invitation_sent_at.in_time_zone("UTC").wday).to eq(Time.now.in_time_zone("UTC").wday)
        end

        it "flashes a notice message" do
            expect(flash[:notice]).to eq "Invitation Re-Sent!"
        end
    end


    describe "GET#sample_csv" do
        it "returns response in csv format" do
            get :sample_csv
            expect(response.content_type).to eq "text/csv"
        end

        it "download sample csv with the following headers: first name, last name, email, biography, active" do 
            get :sample_csv 
            expect(response.body).to include "First name,Last name,Email,Biography,Active"
        end
    end


    describe "GET#import_csv" do
        it "renders import_csv template" do
            get :import_csv
            expect(response).to render_template :import_csv
        end
    end


    describe "GET#parse_csv" do
        before do 
            file = fixture_file_upload('files/test.csv', 'text/csv')
            get :parse_csv, :file => file
        end

        it "renders parse_csv template" do 
            expect(response).to render_template :parse_csv
        end
    end


    describe "GET#export_csv" do
        it "returns success" do
            get :export_csv
            expect(response).to be_success
        end
    end


    describe "GET#date_histogram" do
        it "returns response in csv format" do
            get :date_histogram, :format => :csv
            expect(response.content_type).to eq "text/csv"
        end
        
        it "returns response in json format" do
            get :date_histogram, :format => :json
            expect(response.content_type).to eq "application/json"
        end
    end
end
