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
        end
    end
end