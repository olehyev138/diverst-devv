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
    end

    describe "GET#sent_invitations" do
        it "returns success" do
            get :sent_invitations, :format => :json
            expect(response).to be_success
        end

        it "returns success", :skip => "Missing template" do
            get :sent_invitations, :format => :html
            expect(response).to be_success
        end
    end

    describe "GET#saml_logins" do
        it "returns success" do
            get :saml_logins, :format => :json
            expect(response).to be_success
        end
    end

    describe "GET#new", :skip => "Missing template" do
        it "returns success" do
            get :new
            expect(response).to be_success
        end
    end

    describe "GET#show" do
        it "returns success" do
            get :show, :id => user.id
            expect(response).to be_success
        end
    end

    describe "GET#group_surveys" do
        it "returns success" do
            get :group_surveys, :id => user.id
            expect(response).to be_success
        end
    end

    describe "GET#edit" do
        it "returns success" do
            get :edit, :id => user.id
            expect(response).to be_success
        end
    end

    describe "PATCH#update" do
        before {patch :update, :id => user.id, :user => {:first_name => "updated"}}

        it "redirects to user" do
            expect(response).to redirect_to(user)
        end

        it "updates the user" do
            user.reload
            expect(user.first_name).to eq("updated")
        end

        it "flashes" do
            expect(flash[:notice])
        end
    end
    
    describe "PATCH#resend_invitation" do
        before :each do
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

        it "flashes" do
            expect(flash[:notice])
        end
    end

    describe "delete#destroy" do
        before :each do
            request.env["HTTP_REFERER"] = "back"
            delete :destroy, :id => user.id
        end

        it "redirects" do
            expect(response).to redirect_to "back"
        end

        it "deletes the user" do
            expect(User.where(:id => user.id).count).to eq(0)
        end
    end

    describe "GET#sample_csv" do
        it "returns success" do
            get :sample_csv
            expect(response).to be_success
        end
    end

    describe "GET#import_csv" do
        it "returns success" do
            get :import_csv
            expect(response).to be_success
        end
    end

    describe "GET#parse_csv" do
        it "returns success" do
            file = fixture_file_upload('files/test.csv', 'text/csv')
            get :parse_csv, :file => file
            expect(response).to be_success
        end
    end

    describe "GET#export_csv" do
        it "returns success" do
            get :export_csv
            expect(response).to be_success
        end
    end

    describe "GET#date_histogram", :skip => true do
        it "returns success" do
            get :date_histogram, :format => :csv
            expect(response).to be_success
        end
        
        it "returns success" do
            get :date_histogram, :format => :json
            expect(response).to be_success
        end
    end
end
