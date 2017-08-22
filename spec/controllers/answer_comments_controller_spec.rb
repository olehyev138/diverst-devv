require 'rails_helper'

RSpec.describe AnswerCommentsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    
    describe "DELETE#destroy" do
        describe "with logged in user" do
            let!(:answer_comment){ create(:answer_comment, author_id: user.id) }
            login_user_from_let
            it "destroy the comment" do
                expect{ delete :destroy, id: answer_comment.id }.to change(user.answer_comments, :count).by(-1)
            end
        end
    end
end