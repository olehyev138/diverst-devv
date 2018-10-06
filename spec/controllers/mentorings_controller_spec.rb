require 'rails_helper'

RSpec.describe MentoringsController, type: :controller do
    let(:user) { create :user }
    let(:mentor) { create :user }
    
    describe 'GET #index' do
        describe "if user is present" do 
            login_user_from_let

            it "assigns the mentors" do
                get :index, :mentor => true, :format => :json
                expect(assigns[:users]).to eq([])
            end
            
            it "assigns the mentees" do
                get :index, :mentee => true, :format => :json
                expect(assigns[:users]).to eq([])
            end
        end
    end
    
    describe 'POST #update' do
        describe "if user is present" do 
            login_user_from_let
            
            before {
                request.env["HTTP_REFERER"] = "back"
            }

            it "creates the mentee" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise, :sender => user)
                patch :update, :id => mentoring_request.id
                expect(user.mentees.count).to eq(1)
            end
            
            it "creates the mentor" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise, :receiver => user)
                patch :update, :id => mentoring_request.id
                expect(user.mentors.count).to eq(1)
            end
            
            it "flashes" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise, :receiver => user)
                patch :update, :id => mentoring_request.id
                expect(flash[:notice]).to eq("Your request was approved")
            end
            
            it "destroys" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise, :receiver => user)
                patch :update, :id => mentoring_request.id
                expect{MentoringRequest.find(mentoring_request.id)}.to raise_error ActiveRecord::RecordNotFound
            end
            
            it "redirects back" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise, :receiver => user)
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
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise)
                
                delete :destroy, :id => mentoring_request.id
                expect{MentoringRequest.find(mentoring_request.id)}.to raise_error ActiveRecord::RecordNotFound
            end
            
            it "redirects back" do
                mentoring_request = create(:mentoring_request, :enterprise => user.enterprise)
                delete :destroy, :id => mentoring_request.id
                expect(response).to redirect_to "back"
            end
        end
    end
end
