require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:campaign){ create(:campaign, enterprise: enterprise) }
    let(:question){ create(:question, campaign: campaign) }
    
    describe "PATCH#update" do
        describe "with logged in user" do
            let(:answer){ create(:answer, author_id: user.id, question: question) }
            login_user_from_let
            
            it "updates the answer" do
                patch :update, id: answer.id,  answer: attributes_for(:answer, content: "updated")
                answer.reload
                expect(answer.content).to eq("updated")
            end

            it "render @answer in json format" do 
                patch :update, id: answer.id, answer: attributes_for(:answer, content: "updated")

                answer_response = JSON.parse(response.body, symbolize_names: true)

                answer.reload 
                expect(answer_response[:content]).to eq answer.content
            end
        end
    end
    
    describe "DELETE#destroy" do
        describe "with logged in user" do
            let(:answer){ create(:answer, author_id: user.id, question: question) }
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
    end
end