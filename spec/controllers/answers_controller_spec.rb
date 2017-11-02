require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:campaign){ create(:campaign, enterprise: enterprise) }
    let(:question){ create(:question, campaign: campaign) }
    
    describe "PATCH#update" do
        let(:answer){ create(:answer, author_id: user.id, question: question) }
        
        describe "with logged in user" do
            login_user_from_let

            context "successfully" do 
               before { patch :update, id: answer.id,  answer: attributes_for(:answer, content: "updated") }

                it "updates the answer" do                    
                    answer.reload
                    expect(answer.content).to eq("updated")
                end

                it "render @answer in json format" do 
                    answer_response = JSON.parse(response.body, symbolize_names: true)

                    answer.reload 
                    expect(answer_response[:content]).to eq answer.content
                end
            end

            context "unsuccessfully" do 
                before { patch :update, id: answer.id, answer: attributes_for(:answer, content: nil) }

                it "returns a response of 500" do 
                    expect(response).to have_http_status(500)
                end
            end
        end

        describe "without logged user" do 
            before { patch :update, id: answer.id,  answer: attributes_for(:answer, content: "updated") }

            it "redirect user to users/sign_in path " do 
                expect(response).to redirect_to new_user_session_path
            end

            it 'returns status code of 302' do
                expect(response).to have_http_status(302)
            end
        end
    end
    
    describe "DELETE#destroy" do
        let(:answer){ create(:answer, author_id: user.id, question: question) }

        context "with logged in user" do
            login_user_from_let
            
            it "destroy the answer" do
                delete :destroy, id: answer.id
                user.reload
                
                expect(user.answers.count).to eq (0)
            end

            it "redirect to @question" do 
                delete :destroy, id: answer.id 

                expect(response).to redirect_to(assigns(:question))
            end
        end

        context "without a logged in user" do 
            before { delete :destroy, id: answer.id }


            it "redirect user to users/sign_in path " do 
                expect(response).to redirect_to new_user_session_path
            end

            it 'returns status code of 302' do
                expect(response).to have_http_status(302)
            end
        end
    end
end