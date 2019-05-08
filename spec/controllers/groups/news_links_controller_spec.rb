require 'rails_helper'

RSpec.describe Groups::NewsLinksController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create :user }
  let(:group) { create(:group, enterprise: user.enterprise) }


  describe 'GET #index' do
    def get_index(group_id)
      get :index, group_id: group_id
    end

    let!(:news_link1) { create(:news_link, group: group, created_at: Time.now) }
    let!(:news_link2) { create(:news_link, group: group, created_at: Time.now - 2.hours) }
    let!(:foreign_news_link) { create(:news_link) }

    context 'with logged user' do
      login_user_from_let

      before { get_index(group.to_param) }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it 'assigns correct newslinks' do
        expect(assigns[:news_links]).to include news_link1
      end

      it 'excludes foreign/incorrect link' do
        expect(assigns[:news_links]).to_not include foreign_news_link
      end

      it 'returns news links with newest/latest on top' do
        expect(assigns[:news_links]).to eq [news_link1, news_link2]
      end
    end

    context 'without logged user' do
      before { get_index(group.to_param) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #new' do
    def get_new(group_id)
      get :new, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_new(group.to_param) }

      it 'render new template' do
        expect(response).to render_template :new
      end

      it 'returns a new news_link object' do
        expect(assigns[:news_link]).to be_a_new(NewsLink)
        expect(assigns[:news_link].group).to eq group
      end
    end

    context 'without logged user' do
      before { get_new(group.to_param) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #comments' do
    let!(:news_link) { create(:news_link, group: group) }
    let(:comments) { create_list(:news_link_comment, 2, news_link: news_link) }

    def get_comments(group_id)
      get :comments, group_id: group_id, id: news_link.id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_comments(group.to_param) }

      it 'renders a new comment template' do
        expect(response).to render_template :comments
      end

      it 'returns comment object belong to valid news_link object' do
        expect(assigns[:news_link].comments).to eq comments
      end

      it 'returns a new NewLinkComment object' do
        expect(assigns[:new_comment]).to be_a_new(NewsLinkComment)
      end
    end

    context 'without logged user' do
      before { get_comments(group.to_param) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create_comment' do
    let!(:news_link) { create(:news_link, group: group) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'news_comment', points: 35) }

    before do
      user.enterprise.update(enable_rewards: true)
    end

    describe 'when user is logged in' do
      login_user_from_let

      context 'create comment with valid attributes' do
        it 'creates and saves a new comment object' do
          expect { post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment) }
          .to change(NewsLinkComment, :count).by(1)
        end

        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)

          user.reload
          expect(user.points).to eq 35
        end

        it 'flashes a reward message' do
          post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)
          user.reload
          expect(flash[:reward]).to eq "Your comment was created. Now you have #{user.credits} points"
        end

        it 'redirects to action comments' do
          post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)
          expect(response).to redirect_to(action: :comments)
        end
      end

      context 'with invalid attributes' do
        invalid_attributes = FactoryBot.attributes_for(:news_link_comment)
        let!(:invalid_attributes) { invalid_attributes[:content] = nil }

        it 'does not create a comment' do
          expect { post :create_comment, group_id: group.id, id: news_link, news_link_comment: invalid_attributes }
          .to change(NewsLinkComment, :count).by(0)
        end

        it 'flashes an alert message' do
          post :create_comment, group_id: group.id, id: news_link, news_link_comment: invalid_attributes
          expect(flash[:alert]).to eq 'Your comment was not created. Please fix the errors'
        end

        it 'redirects to action comments' do
          post :create_comment, group_id: group.id, id: news_link, news_link_comment: invalid_attributes
          expect(response).to redirect_to(action: :comments)
        end
      end
    end

    describe 'without logged user' do
      before { post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST#create' do
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'news_post', points: 30) }
    before { user.enterprise.update(enable_rewards: true) }

    describe 'with user logged in' do
      login_user_from_let
      context 'with valid attributes' do
        it 'create a new NewsLink object' do
          expect { post :create, group_id: group.id, news_link: attributes_for(:news_link) }
          .to change(NewsLink, :count).by(1)
        end

        it 'rewards a user with points of this action' do
          expect(user.points).to eq 0

          post :create, group_id: group.id, news_link: attributes_for(:news_link)

          user.reload
          expect(user.points).to eq 30
        end

        it 'flashes a reward message' do
          post :create, group_id: group.id, news_link: attributes_for(:news_link)
          user.reload
          expect(flash[:reward]).to eq "Your news was created. Now you have #{user.credits} points"
        end

        it 'redirects to group_posts_path' do
          post :create, group_id: group.id, news_link: attributes_for(:news_link)
          expect(response).to redirect_to group_posts_path(group)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                post :create, group_id: group.id, news_link: attributes_for(:news_link)
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { NewsLink.last }
            let(:owner) { user }
            let(:key) { 'news_link.create' }

            before {
              perform_enqueued_jobs do
                post :create, group_id: group.id, news_link: attributes_for(:news_link)
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid attributes' do
        invalid_link_attributes = FactoryBot.attributes_for(:news_link)
        let!(:invalid_link_attributes) { invalid_link_attributes[:title] = nil }

        it 'does not create a news link object' do
          expect { post :create, group_id: group.id, news_link: invalid_link_attributes }
          .to change(NewsLink, :count).by(0)
        end

        it 'flashes an alert message' do
          post :create, group_id: group.id, news_link: invalid_link_attributes
          expect(flash[:alert]).to eq 'Your news was not created. Please fix the errors'
        end

        it 'renders edit template' do
          post :create, group_id: group.id, news_link: invalid_link_attributes
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without logged user' do
      before { post :create, group_id: group.id, news_link: attributes_for(:news_link) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    let!(:news_link) { create(:news_link, group: group) }

    describe 'when user is logged in' do
      login_user_from_let

      context 'with valid attributes' do
        before { patch :update, group_id: group.id, id: news_link.id, news_link: { title: 'updated' } }

        it 'redirects to group_posts_path' do
          expect(response).to redirect_to group_posts_path(group)
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq 'Your news was updated'
        end

        it 'updates the link' do
          news_link.reload
          expect(news_link.title).to eq('updated')
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :update, group_id: group.id, id: news_link.id, news_link: { title: 'updated' }
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { NewsLink.last }
            let(:owner) { user }
            let(:key) { 'news_link.update' }

            before {
              perform_enqueued_jobs do
                patch :update, group_id: group.id, id: news_link.id, news_link: { title: 'updated' }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'with invalid attributes' do
        let!(:news_link) { create(:news_link, group: group) }
        before { patch :update, group_id: group.id, id: news_link.id, news_link: { title: nil } }

        it 'flashes an alert message' do
          expect(flash[:alert]).to eq 'Your news was not updated. Please fix the errors'
        end

        it 'renders an edit template' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'without logged user' do
      before { patch :update, group_id: group.id, id: news_link.id, news_link: { title: 'updated' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'DELETE#destroy' do
    let!(:news_link) { create(:news_link, group: group) }
    let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: 'news_post', points: 90) }
    before { Rewards::Points::Manager.new(user, reward_action.key).add_points(news_link) }

    context 'when user is logged in' do
      login_user_from_let

      it 'remove reward points of a user with points of this action' do
        expect(user.points).to eq 90

        delete :destroy, group_id: group.id, id: news_link.id

        user.reload
        expect(user.points).to eq 0
      end

      it 'deletes news link object' do
        expect { delete :destroy, group_id: group.id, id: news_link.id }
        .to change(NewsLink, :count).by(-1)
      end

      it 'flashes a notice message' do
        delete :destroy, group_id: group.id, id: news_link.id
        user.reload
        expect(flash[:notice]).to eq "Your news was removed. Now you have #{user.credits} points"
      end

      it 'redirects to group_posts_path' do
        delete :destroy, group_id: group.id, id: news_link.id
        expect(response).to redirect_to group_posts_path(group)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect {
              delete :destroy, group_id: group.id, id: news_link.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { NewsLink.last }
          let(:owner) { user }
          let(:key) { 'news_link.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, group_id: group.id, id: news_link.id
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when users is not logged in' do
      before { delete :destroy, group_id: group.id, id: news_link.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#archive' do
    let!(:news_link) { create(:news_link, group: group) }

    describe 'when user is logged in' do
      before { request.env['HTTP_REFERER'] = 'back' }

      login_user_from_let

      context 'with valid attributes' do
        before { patch :archive, group_id: group.id, id: news_link.id }

        it 'redirects to same page' do
          expect(response).to redirect_to 'back'
        end

        it 'archives news_link' do
          expect(assigns[:news_link].news_feed_link.archived_at).to_not be_nil
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :archive, group_id: group.id, id: news_link.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { NewsLink.last }
            let(:owner) { user }
            let(:key) { 'news_link.archive' }

            before {
              perform_enqueued_jobs do
                patch :archive, group_id: group.id, id: news_link.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end
  end
end
