require 'rails_helper'

RSpec.describe User::MentorshipController, type: :controller do
    let(:user) { create :user }

    describe 'GET #index' do
        describe "if user is present" do 
            login_user_from_let

            it "render profile page" do
                get :index
                expect(assigns[:user].id).to eq(user.id)
            end
        end
    end
    
    describe "PATCH#update" do
        describe 'when user is logged in' do
            login_user_from_let

            context "for a successful update" do
                before do
                    request.env["HTTP_REFERER"] = "back"
                    patch :update, :id => user.id, :user => {:mentor => true}
                end

                it "redirects back" do
                    expect(response).to redirect_to action: :mentors
                end

                it "updates the user" do
                    user.reload
                    expect(user.mentor).to be(true)
                end

                it "flashes a notice message" do
                    expect(flash[:notice]).to eq "Your user was updated"
                end
            end

            context "for an unsuccessful update" do
                before { 
                    request.env["HTTP_REFERER"] = "back"
                    allow_any_instance_of(User).to receive(:save).and_return(false)
                    patch :update, :id => user.id, :user => { :mentor => false } 
                }

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq "Your user was not updated. Please fix the errors"
                end

                it "redirects back" do
                    expect(response).to redirect_to "back"
                end
            end
        end
    end
    
    describe 'GET #mentors' do
        describe "if user is present" do 
            login_user_from_let

            it "sets the mentors" do
                get :mentors
                expect(assigns[:mentors]).to eq([])
            end
        end
    end
    
    describe 'GET #mentees' do
        describe "if user is present" do 
            login_user_from_let

            it "sets the mentees" do
                get :mentees
                expect(assigns[:mentees]).to eq([])
            end
        end
    end
    
    describe 'GET #requests' do
        describe "if user is present" do 
            login_user_from_let

            it "sets the mentorship_requests and mentorship_proposals" do
                get :requests
                expect(assigns[:mentorship_requests]).to eq([])
                expect(assigns[:mentorship_proposals]).to eq([])
            end
        end
    end
    
    describe 'GET #sessions' do
        describe "if user is present" do 
            login_user_from_let

            it "sets the sessions" do
                get :sessions
                expect(assigns[:sessions]).to eq([])
            end
        end
    end
    
    describe 'GET #ratings' do
        describe "if user is present" do 
            login_user_from_let

            it "sets the ratings" do
                get :ratings
                expect(assigns[:ratings]).to eq([])
            end
        end
    end
end
