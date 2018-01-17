require 'rails_helper'

RSpec.describe Groups::NewsLinkCommentController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  let(:news_link){ create(:news_link, group: group, author: user) }
  let(:news_link_comment){ create(:news_link_comment, news_link: news_link, approved: false) }
  
  login_user_from_let

  describe 'GET#edit' do
    it "edits news link comment" do
      get :edit, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id
      expect(response).to be_success
    end
  end

  describe 'PATCH#update' do
    context "when successful" do
      before(:each) do
        patch :update, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id, news_link_comment: {content: "updated", approved: true}
      end
  
      it "updates the comment" do
        news_link_comment.reload
        expect(news_link_comment.content).to eq "updated"
        expect(news_link_comment.approved).to be true
      end
  
      it "redirect to message" do
        expect(response).to redirect_to comments_group_news_link_url(:id => news_link.id, :group_id => group.id)
      end
    end
    
    context "when unsuccessful" do
      before {
        allow_any_instance_of(NewsLinkComment).to receive(:update).and_return(false)
        patch :update, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id, news_link_comment: {content: "updated", approved: true}
      }
  
      it "does not update the comment" do
        news_link_comment.reload
        expect(news_link_comment.content).to_not eq "updated"
        expect(news_link_comment.approved).to_not be true
      end
  
      it "renders edit" do
        expect(response).to render_template :edit
      end
      
      it "flashes" do
        expect(flash[:alert]).to eq "Your comment was not updated. Please fix the errors"
      end
    end
  end

  describe 'DELETE#destroy' do
    before(:each) do
      delete :destroy, group_id: group.id, news_link_id: news_link.id, id: news_link_comment.id
    end
    
    it "removes the comment" do
      expect{NewsLinkComment.find(news_link_comment.id)}.to raise_error ActiveRecord::RecordNotFound
    end
    
    it "redirect to news_link" do
      expect(response).to redirect_to comments_group_news_link_url(:id => news_link.id, :group_id => group.id)
    end
  end
end
