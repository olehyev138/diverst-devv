require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let(:match){ create(:match, user1_id: user.id, user2_id: user2.id) }
    
    def sign_in
        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)
    end
    
    describe "GET#index" do
        context "with logged in user" do
            before {
                sign_in
                get :index
            }
            
            it "returns 200" do
                expect(response.status).to eq(200)
            end
            
            it "gets the user conversations" do
                conversations = JSON.parse(response.body)
                expect(conversations.length).to eq(0)
            end
        end
        
        context "with logged out user" do
            it "returns 401" do
                get :index
                expect(response.status).to eq(401)
            end
        end
    end

    describe "DELETE#destroy" do
        context "with logged in user" do
            context "when updated" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    delete :destroy, id: match.id
                }
    
                it "destroy the match" do
                    expect(response.status).to eq(204)
                end
            end
            
            context "when not updated" do
                before {
                    allow_any_instance_of(Match).to receive(:update_attributes).and_return(false)
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    delete :destroy, id: match.id
                }
    
                it "destroy the match" do
                    expect(response.status).to eq(500)
                end
            end
        end
    end

    describe "PUT#opt_in" do
        context "with logged in user" do
            
            context "when rating is incorrect" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.user1_rating = 2
                    match.save!
                    
                    sign_in
                    put :opt_in, id: match.id, :rating => 6
                }
    
                it "return 400 status" do
                    expect(response.status).to eq(400)
                end
                
                it "returns message" do
                    message = JSON.parse(response.body)
                    expect(message["message"]).to eq("Rating must be from 1 to 5")
                end
            end
            
            context "when updated" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    put :opt_in, id: match.id, :rating => "1"
                }
    
                it "update the match" do
                    expect(response.status).to eq(200)
                end
            end
            
            context "when not updated" do
                before {
                    allow_any_instance_of(Match).to receive(:save).and_return(false)
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    put :opt_in, id: match.id, :rating => "1"
                }
    
                it "returns 422 error status" do
                    expect(response.status).to eq(422)
                end
            end
        end
    end
    
    describe "PUT#leave" do
        context "with logged in user" do
            context "when rating is missing" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    put :leave, id: match.id, rating: 6
                }
    
                it "returns 400 status" do
                    expect(response.status).to eq(400)
                end
                
                it "returns message" do
                    message = JSON.parse(response.body)
                    expect(message["message"]).to eq("Rating must be from 1 to 5")
                end
            end
            
            context "when rating is already set" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.user1_rating = 1
                    match.save!
                    
                    sign_in
                    put :leave, id: match.id, rating: 5
                }
    
                it "returns 400 status" do
                    expect(response.status).to eq(400)
                end
                
                it "returns message" do
                    message = JSON.parse(response.body)
                    expect(message["message"]).to eq("Rating is already set")
                end
            end
            
            context "when updated" do
                before {
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    put :leave, id: match.id, :rating => "1"
                }
    
                it "update the match" do
                    expect(response.status).to eq(200)
                end
            end
            
            context "when not updated" do
                before {
                    allow_any_instance_of(Match).to receive(:save).and_return(false)
                    match.user2_status = 1
                    match.user1_status = 1
                    match.save!
                    
                    sign_in
                    put :leave, id: match.id, :rating => "1"
                }
    
                it "returns 422 error status" do
                    expect(response.status).to eq(422)
                end
            end
        end
    end
end