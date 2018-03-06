require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    let(:enterprise) { create(:enterprise, cdo_name: "test") }
    let(:user) { create(:user, enterprise: enterprise) }

    describe "GET#index" do
        context 'when user is logged in' do
            login_user_from_let

            it "returns an html response" do
                get :index, :id => user.id
                expect(response.content_type).to eq "text/html"
            end

            it 'renders index template' do
                get :index, :id => user.id
                expect(response).to render_template :index
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

        context 'when user is not logged in' do
            before { get :index, :id => user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#sent_invitations" do
        context 'when user is logged in' do
            login_user_from_let

            it "returns a json response" do
                get :sent_invitations, :format => :json
                expect(response.content_type).to eq "application/json"
            end
        end

        context 'when user is not logged in' do
            before { get :sent_invitations, :format => :json }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#saml_logins" do
        context 'when user is logged in' do
            login_user_from_let

            it "returns data in json" do
                get :saml_logins, :format => :json
                expect(response.content_type).to eq 'application/json'
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

        context 'when user is not logged in' do 
            before { get :saml_logins, :format => :json }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    #NOTE: Missing Template for new method

    describe "GET#show" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :show, :id => user.id  }


            it "render show template" do
                expect(response).to render_template :show
            end

            it "returns a valid user" do
                expect(assigns[:user]).to be_valid
            end
        end

        context 'when user is not logged in' do 
            before { get :show, :id => user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#group_surveys" do
        context 'when user is logged in' do
            let!(:groups) { create_list(:group, 2, enterprise: enterprise) }
            let!(:user_group1) { create(:user_group, user: user, group_id: groups.first.id, data: "some text") }
            let!(:user_group2) { create(:user_group, user: user, group_id: groups.last.id, data: "some text") }
            login_user_from_let 

            it "returns success" do
                get :group_surveys, :id => user.id
                expect(response).to be_success
            end

            it "returns manageable group ids" do
                manageable_group_ids = [groups.first.id, groups.last.id]
                get :group_surveys, :id => user.id
                expect(assigns[:user].enterprise.group_ids).to eq manageable_group_ids
            end

            it "returns user groups with data attribute not set to nil" do
                manageable_group_ids = [groups.first.id, groups.last.id]
                get :group_surveys, :id => user.id
                expect(assigns[:user_groups].count).to eq 2
            end
        end

        context 'when user is not logged in' do 
            before { get :group_surveys, :id => user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#edit" do
        context 'when user is logged in' do
            login_user_from_let

            it "render template" do
                get :edit, :id => user.id
                expect(response).to render_template :edit
            end

            it "returns a valid user object" do
                get :edit, :id => user.id
                expect(assigns[:user]).to be_valid
            end
        end

        context 'when user is not logged in' do 
            before { get :edit, :id => user.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#update" do
        describe 'when user is logged in' do
            login_user_from_let

            context "for a successful update" do
                before do
                    request.env["HTTP_REFERER"] = "back"
                    patch :update, :id => user.id, :user => {:first_name => "updated"}
                end

                it "redirects to user" do
                    expect(response).to redirect_to "back"
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

        describe 'when user is not logged in' do 
            before do 
                request.env["HTTP_REFERER"] = "back"
                patch :update, :id => user.id, :user => {:first_name => "updated"}
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "delete#destroy" do
        context 'when user is logged in' do
            login_user_from_let
            before do
                request.env["HTTP_REFERER"] = "back"
            end

            it "redirects to previous url" do
                delete :destroy, :id => user.id
                expect(response).to redirect_to "back"
            end

            it "deletes the user" do
                expect{delete :destroy, :id => user.id}
                .to change(User, :count).by(-1)
            end
        end

        context 'when user is not logged in' do 
            before do 
                request.env["HTTP_REFERER"] = "back"
                delete :destroy, :id => user.id
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "PATCH#resend_invitation" do
        context 'when user is logged in' do
            login_user_from_let
            before do
                request.env["HTTP_REFERER"] = "back"
                patch :resend_invitation, :id => user.id
            end


            it "updates the user invitation_sent_at" do
                user.reload
                expect(user.invitation_sent_at.in_time_zone("UTC").wday).to eq(Time.now.in_time_zone("UTC").wday)
            end

            it "flashes a notice message" do
                expect(flash[:notice]).to eq "Invitation Re-Sent!"
            end

            it "redirects to back" do
                expect(response).to redirect_to "back"
            end
        end

        context 'when user is not logged in' do 
            before do 
                request.env["HTTP_REFERER"] = "back"
                patch :resend_invitation, :id => user.id
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#sample_csv" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :sample_csv }

            it "returns response in csv format" do
                expect(response.content_type).to eq "text/csv"
            end

            it "download sample csv with the following headers: first name, last name, email, biography, active" do
                expect(response.body).to include "First name,Last name,Email,Biography,Active"
            end
        end

        context 'when user is not logged in' do 
            before { get :sample_csv }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#import_csv" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :import_csv } 

            it "renders import_csv template" do
                expect(response).to render_template :import_csv
            end
        end

        context 'when user is not logged in' do 
            before { get :import_csv }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#parse_csv" do
        let!(:file) { fixture_file_upload('files/test.csv', 'text/csv') }

        context 'when user is logged in' do
            login_user_from_let
            before { get :parse_csv, :file => file }

            it "renders parse_csv template" do
                expect(response).to render_template :parse_csv
            end
        end

        context 'when user is not logged in' do
            before { get :parse_csv, :file => file }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#export_csv" do
        context 'when user is logged in' do
            login_user_from_let
            before { get :export_csv }

            it "return data in csv format" do
                expect(response.content_type).to eq 'text/csv'
            end

            it "filename should be 'diverst_users.csv'" do 
                expect(response.headers["Content-Disposition"]).to include 'diverst_users.csv'
            end
        end

        context 'when user is not logged in' do 
            before { get :export_csv }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "GET#date_histogram", skip: "inconsistent test results" do
        context 'user is logged in' do 
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
end
