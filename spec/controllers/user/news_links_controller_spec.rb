require 'rails_helper'

RSpec.describe User::NewsLinksController, type: :controller do
  let!(:user) { create :user }
  let!(:groups) { create_list(:group, 2, owner: user) }
  let!(:news_links) { create_list(:news_link, 12, author: user, group: groups.first) }
  let!(:news_feeds) { create_list(:news_feed, 12, group: groups.first) }
  let!(:news_feed_links) { create_list(:news_feed_link, 12, news_feed: news_feeds.first) }
  let!(:segment) { create(:segment, owner: user) }
  let!(:news_feed_link_segments) { create_list(:news_feed_link_segment, 12, news_feed_link: news_feed_links.first, segment: segment) }

  before do
    user.groups = groups
    user.segments << segment
  end


  describe 'GET #index' do
    describe 'when user is logged in' do
      login_user_from_let

      before { get :index }

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'return posts limited to 5' do
        expect(assigns[:posts].count).to eq 5
      end

      xit 'assert @count to be greater than limited(5)' do
        expect(assigns[:count]).to be > assigns[:posts].count
      end
    end

    describe 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
