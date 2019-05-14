require 'rails_helper'

RSpec.describe Groups::GroupMessageCommentController, type: :controller do
  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }
  let(:group_message) { create(:group_message, group: group, subject: 'Test', owner: user) }
  let(:group_message_comment) { create(:group_message_comment, message: group_message, approved: false) }


  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :edit, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id }

      it 'renders edit template' do
        expect(response).to render_template :edit
      end

      it 'returns comment belonging to group_message' do
        expect(assigns[:comment]).to eq group_message_comment
        expect(assigns[:comment].message).to eq group_message
      end
    end

    context 'when user is not logged in' do
      before { get :edit, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'PATCH#update' do
    context 'with valid attributes' do
      login_user_from_let

      before do
        patch :update, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id, group_message_comment: { content: 'updated' }
      end

      it 'updates the comment' do
        group_message_comment.reload
        expect(assigns[:comment].content).to eq 'updated'
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq 'Your comment was updated'
      end

      it 'redirect to message' do
        expect(response).to redirect_to group_group_message_url(id: group_message.id, group_id: group.id)
      end
    end

    context 'with invalid attributes' do
      login_user_from_let
      before do
        patch :update, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id, group_message_comment: { content: nil }
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq 'Your comment was not updated. Please fix the errors'
      end

      it 'renders edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'when user is not logged in' do
      before { patch :update, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id, group_message_comment: { content: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE#destroy' do
    context 'when user is logged in' do
      login_user_from_let

      before do
        delete :destroy, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id
      end

      it 'removes the comment' do
        expect { GroupMessageComment.find(group_message_comment.id) }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'redirect to message' do
        expect(response).to redirect_to group_group_message_url(id: group_message.id, group_id: group.id)
      end
    end

    context 'when user is not logged in' do
      before do
        delete :destroy, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id
      end

      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
