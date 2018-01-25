require 'rails_helper'

RSpec.describe AnswerCommentsController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:campaign){ create(:campaign, enterprise: enterprise) }
    let(:question){ create(:question, campaign: campaign) }
    let(:answer){ create(:answer, question: question) }

    describe "PUT#update" do
        describe "with logged in user" do
            let!(:answer_comment){ create(:answer_comment, answer: answer, author_id: user.id, approved: false) }
            login_user_from_let

            context "when successful" do
                before {
                    request.env["HTTP_REFERER"] = "back"
                    put :update, id: answer_comment.id, answer_comment: {approved: true}
                }

                it "update the comment" do
                    answer_comment.reload
                    expect(answer_comment.approved).to be(true)
                end

                it "redirects back" do
                    expect(response).to redirect_to "back"
                end

                it "flashes" do
                    expect(flash[:notice]).to eq "The comment was updated"
                end
            end

            context "when successful" do
                before {
                    request.env["HTTP_REFERER"] = "back"
                    allow_any_instance_of(AnswerComment).to receive(:update).and_return(false)
                    put :update, id: answer_comment.id, answer_comment: {approved: true}
                }

                it "doesn't update the comment" do
                    answer_comment.reload
                    expect(answer_comment.approved).to_not be(true)
                end

                it "redirects back" do
                    expect(response).to redirect_to "back"
                end

                it "flashes" do
                    expect(flash[:alert]).to eq "The comment was not updated"
                end
            end
        end

        describe "without a logged in user" do
            let!(:answer_comment){ create(:answer_comment, answer: answer, author_id: user.id) }
            before { put :update, id: answer_comment.id, answer_comment: {approved: true} }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe "DELETE#destroy" do
        describe "with logged in user" do
            let!(:answer_comment){ create(:answer_comment, answer: answer, author_id: user.id) }
            login_user_from_let

            it "destroy the comment" do
                expect{ delete :destroy, id: answer_comment.id }.to change(user.answer_comments, :count).by(-1)
            end

            it "redirects to @answer" do
                delete :destroy, id: answer_comment.id

                expect(response).to redirect_to(assigns(:answer))
            end
        end

        describe "without a logged in user" do
            let!(:answer_comment){ create(:answer_comment, answer: answer, author_id: user.id) }
            before { delete :destroy, id: answer_comment.id }

            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end