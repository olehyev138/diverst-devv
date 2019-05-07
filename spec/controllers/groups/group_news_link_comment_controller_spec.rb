require 'rails_helper'

RSpec.describe Groups::NewsLinkCommentController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:news_link) { create(:news_link, group: group, author: user) }
  let(:news_link_comment) { create(:news_link_comment, news_link: news_link, approved: false) }



  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id }

      it 'renders edit template' do
        expect(response).to render_template :edit
      end

      it 'returns comment belonging to news link' do
        expect(assigns[:comment]).to eq news_link_comment
        expect(assigns[:comment].news_link).to eq news_link
      end
    end

    context 'when user is not logged in' do
      before { get :edit, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'when successful' do
        before do
          patch :update, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id, news_link_comment: { content: 'updated', approved: true }
        end

        it 'updates the comment' do
          news_link_comment.reload
          expect(assigns[:comment].content).to eq 'updated'
          expect(assigns[:comment].approved).to be true
        end

        it 'redirect to message' do
          expect(response).to redirect_to comments_group_news_link_url(id: news_link.id, group_id: group.id)
        end
      end

      context 'when unsuccessful' do
        before {
          allow_any_instance_of(NewsLinkComment).to receive(:update).and_return(false)
          patch :update, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id, news_link_comment: { content: 'updated', approved: true }
        }

        it 'does not update the comment' do
          news_link_comment.reload
          expect(news_link_comment.content).to_not eq 'updated'
          expect(news_link_comment.approved).to_not be true
        end

        it 'renders edit' do
          expect(response).to render_template :edit
        end

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your comment was not updated. Please fix the errors'
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        patch :update, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id, news_link_comment: { content: 'updated', approved: true }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let
      before do
        delete :destroy, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id
      end

      it 'removes the comment' do
        expect { NewsLinkComment.find(news_link_comment.id) }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'redirect to news_link' do
        expect(response).to redirect_to comments_group_news_link_url(id: news_link.id, group_id: group.id)
      end
    end

    context 'when user is not logged in' do
      before do
        delete :destroy, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
