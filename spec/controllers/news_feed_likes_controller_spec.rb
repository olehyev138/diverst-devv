require 'rails_helper'

RSpec.describe NewsFeedLikesController, type: :controller do
  let(:enterprise) { create :enterprise }
  let (:user) { create :user, :enterprise => enterprise }
  let(:group) { create(:group, enterprise: user.enterprise) }

  let(:news_link) { create(:news_link, group: group, created_at: Time.now) }

  describe 'POST#create' do
    context 'with logged in user' do
      login_user_from_let

        it 'likes a post' do
          expect{ post :create, news_feed_link_id: news_link.news_feed_link.id }
            .to change(NewsFeedLike, :count).by(1)
        end

        it 'unlikes a post' do
          post :create, news_feed_link_id: news_link.news_feed_link.id

          expect{ post :unlike, news_feed_link_id: news_link.news_feed_link.id }
            .to change(NewsFeedLike, :count).by(-1)
        end
    end

    context 'with logged out user' do
      it 'doesnt like the post' do
        expect{ post :create, news_feed_link_id: news_link.news_feed_link.id }
          .to change(NewsFeedLike, :count).by(0)
      end
    end
  end
end
