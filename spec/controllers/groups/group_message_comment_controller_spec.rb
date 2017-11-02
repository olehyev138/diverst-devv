require 'rails_helper'

RSpec.describe Groups::GroupMessageCommentController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  let(:group_message){ create(:group_message, group: group, subject: "Test", owner: user) }
  let(:group_message_comment){ create(:group_message_comment, message: group_message) }
  
  login_user_from_let

  describe 'GET#edit' do
    it "edits group message comment" do
      get :edit, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id
      expect(response).to be_success
    end
  end

  describe 'PATCH#update' do
    before(:each) do
      patch :update, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id, group_message_comment: {content: "updated"}
    end

    it "updates the comment" do
      group_message_comment.reload
      expect(group_message_comment.content).to eq "updated"
    end

    it "redirect to message" do
      expect(response).to redirect_to group_group_message_url(:id => group_message.id, :group_id => group.id)
    end
  end

  describe 'DELETE#destroy' do
    before(:each) do
      delete :destroy, group_id: group.id, group_message_id: group_message.id, id: group_message_comment.id
    end
    
    it "removes the comment" do
      expect{GroupMessageComment.find(group_message_comment.id)}.to raise_error ActiveRecord::RecordNotFound
    end
    
    it "redirect to message" do
      expect(response).to redirect_to group_group_message_url(:id => group_message.id, :group_id => group.id)
    end
  end
end
