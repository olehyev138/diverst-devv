require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:enterprise) { create :enterprise }
  let(:user) { create :user, enterprise: enterprise }
  let(:group) { create(:group, enterprise: user.enterprise) }

  let(:news_link) { create(:news_link, group: group, created_at: Time.now) }
  let(:answer) { create(:answer) }

  describe 'POST#create' do
    context 'with logged in user' do
      login_user_from_let

      it 'likes a post' do
        expect { post :create, news_feed_link_id: news_link.news_feed_link.id }
          .to change(Like, :count).by(1)
      end

      it 'increases AnswerUpvote count' do
        expect { post :create, answer_id: answer.id }
          .to change(AnswerUpvote, :count).by(1)
      end

      it 'unlikes a post' do
        post :create, news_feed_link_id: news_link.news_feed_link.id

        expect { post :unlike, news_feed_link_id: news_link.news_feed_link.id }
          .to change(Like, :count).by(-1)
      end

      it 'likes an answer' do
        expect { post :create, answer_id: answer.id }
          .to change(Like, :count).by(1)
      end
    end

    describe 'DELETE #unlike' do
      context 'with logged in user' do
        let!(:like) { create(:like, answer_id: answer.id, user_id: user.id, enterprise: enterprise) }

        login_user_from_let

        it 'decreases AnswerUpvote count' do
          create(:answer_upvote, answer_id: answer.id, author_id: user.id)
          expect { delete :unlike, answer_id: answer.id }.to change(AnswerUpvote, :count).by(-1)
        end

        it 'unlikes an answer' do
          expect { delete :unlike, answer_id: answer.id }
            .to change(Like, :count).by(-1)
        end
      end
    end


    context 'with logged out user' do
      it 'doesnt like the post' do
        expect { post :create, news_feed_link_id: news_link.news_feed_link.id }
          .to_not change(Like, :count)
      end
    end
  end
end
