require 'rails_helper'

RSpec.describe MentoringSessionsController, type: :controller do
    let(:user) { create :user }
    let(:mentor) { create :user }
    
    describe 'GET #new' do
        describe "if user is present" do 
            login_user_from_let

            it "assigns the mentoring_session" do
                get :new
                expect(assigns[:mentoring_session].status).to eq("scheduled")
            end
            
            it "renders the template" do
                get :new
                expect(response).to render_template('user/mentorship/sessions/new')
            end
        end
    end
    
    describe 'GET #show' do
        describe "if user is present" do 
            login_user_from_let
            it "renders the template" do
                mentoring_session = create(:mentoring_session)
                mentoring_session.mentorship_sessions.create(:user => user, :mentoring_session => mentoring_session)
                
                get :show, :id => mentoring_session.id
                expect(response).to render_template('user/mentorship/sessions/show')
            end
        end
    end
    
    describe 'POST #create' do
        describe "if user is present" do 
            login_user_from_let

            it "creates the request" do
                post :create, :mentoring_session => {:start => Date.today, :end => Date.tomorrow, :notes => "Please mentor me!", :format => "Webex"}
                expect(MentoringSession.count).to eq(1)
            end
            
            it "flashes" do
                allow_any_instance_of(MentoringSession).to receive(:save).and_return(false)
                post :create, :mentoring_session => {:start => Date.today, :end => Date.tomorrow, :notes => "Please mentor me!", :format => "Webex"}
                expect(flash[:alert]).to eq("Your session was not scheduled")
            end
        end
    end
    
    describe 'DELETE #destroy' do
        describe "if user is present" do 
            
            login_user_from_let
            before {
                request.env["HTTP_REFERER"] = "back"
            }
            
            it "destroys the request" do
                mentoring_session = create(:mentoring_session)
                mentoring_session.mentorship_sessions.create(:user => user, :mentoring_session => mentoring_session)
                
                delete :destroy, :id => mentoring_session.id
                expect{MentoringSession.find(mentoring_session.id)}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
end
