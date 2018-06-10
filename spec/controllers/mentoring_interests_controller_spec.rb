require 'rails_helper'

RSpec.describe MentoringInterestsController, type: :controller do
    let(:user) { create :user }
    let(:mentor) { create :user }
    
    describe 'GET #index' do
        describe "if user is present" do 
            login_user_from_let

            it "assigns the mentors" do
                get :index
                expect(assigns[:topics]).to eq([])
            end
        end
    end
    
    describe 'GET #new' do
        describe "if user is present" do 
            login_user_from_let

            it "assigns the topic" do
                get :new
                expect(assigns[:topic].enterprise_id).to eq(user.enterprise_id)
            end
        end
    end
    
    describe 'POST #create' do
        describe "if user is present" do 
            login_user_from_let
            
            context "when it saves" do
                before {post :create, :mentoring_interest => {:name => "Test"}}
                
                it "creates the topic/interest" do
                    expect(MentoringInterest.count).to eq(1)
                end
                
                it "flashes" do
                    expect(flash[:notice]).to eq("Your topic was created")
                end
                
                it "redirect_to index" do
                    expect(response).to redirect_to action: :index
                end
            end
            
            context "when it doesn't save" do
                before {
                    allow_any_instance_of(MentoringInterest).to receive(:save).and_return(false)
                    post :create, :mentoring_interest => {:name => "Test"}
                }
                
                it "flashes" do
                    expect(flash[:alert]).to eq("Your topic was not created. Please fix the errors")
                end
                
                it "does not create the topic/interest" do
                    expect(MentoringInterest.count).to eq(0)
                end
                
                it "redirect_to index" do
                    expect(response).to render_template :new
                end
            end
        end
    end
    
    describe 'GET #edit' do
        describe "if user is present" do 
            login_user_from_let

            it "assigns the topic" do
                topic = create(:mentoring_interest, :enterprise_id => user.enterprise_id)
                get :edit, :id => topic.id
                expect(assigns[:topic].id).to eq(topic.id)
            end
        end
    end
    
    describe 'PUT #update' do
        describe "if user is present" do 
            
            login_user_from_let
            before {
                request.env["HTTP_REFERER"] = "back"
            }
            
            it "creates the request for the user as the mentor" do
                mentoring_request = create(:mentoring_request, :sender => user, :receiver => mentor, :enterprise => user.enterprise)
                patch :update, :id => mentoring_request.id
                expect(flash[:notice]).to eq("Your request was approved")
            end
            
            it "creates the request for the user as the mentee" do
                mentoring_request = create(:mentoring_request, :sender => mentor, :receiver => user, :enterprise => user.enterprise)
                patch :update, :id => mentoring_request.id
                expect(flash[:notice]).to eq("Your request was approved")
            end
            
            it "redirects back" do
                mentoring_request = create(:mentoring_request, :sender => user, :receiver => mentor, :enterprise => user.enterprise)
                patch :update, :id => mentoring_request.id
                expect(response).to redirect_to "back"
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
                mentoring_request = create(:mentoring_request, :sender => user, :receiver => mentor, :enterprise => user.enterprise)
                delete :destroy, :id => mentoring_request.id
                expect{MentoringRequest.find(mentoring_request.id)}.to raise_error ActiveRecord::RecordNotFound
            end
        end
    end
end
