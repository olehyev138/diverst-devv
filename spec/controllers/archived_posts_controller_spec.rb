require 'rails_helper'

RSpec.describe ArchivedPostsController, type: :controller do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:group) { create(:group, enterprise: user.enterprise) }

  describe 'GET #index' do
    before do
      create_list(:news_link, 2, group: group)
      create_list(:group_message, 2, group: group)
      NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
    end

    context 'with logged in user' do
      login_user_from_let
      before { get :index }

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'returns all archived posts via archived news_feed_link' do
        expect(assigns[:posts].count).to eq 4
      end
    end
  end

  describe 'DELETE#destroy' do
    let!(:news_link) { create(:news_link, group: group) }
    before do
      request.env['HTTP_REFERER'] = 'back'
      news_link.news_feed_link.update(archived_at: DateTime.now.months_ago(3))
    end

    context 'with logged in user' do
      login_user_from_let

      it 'delete archived post' do
        expect { delete :destroy, id: news_link.news_feed_link.id }.to change(NewsFeedLink, :count).by(-1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect {
              delete :destroy, id: news_link.news_feed_link.id
            }.to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { NewsLink.last }
          let(:owner) { user }
          let(:key) { 'news_link.destroy' }

          before {
            perform_enqueued_jobs do
              delete :destroy, id: news_link.news_feed_link.id
            end
          }

          include_examples 'correct public activity'
        end
      end

      it 'redirect back' do
        delete :destroy, id: news_link.news_feed_link.id
        expect(response).to redirect_to 'back'
      end
    end
  end

  describe 'POST#delete_all' do
    before do
      request.env['HTTP_REFERER'] = 'back'
      create_list(:news_link, 2, group: group)
      create_list(:group_message, 2, group: group)
      NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
    end

    context 'with logged in user' do
      login_user_from_let

      it 'deletes all archived posts' do
        expect { post :delete_all }.to change(NewsFeedLink, :count).by(-4)
      end

      it 'flashes notice message all archived posts deleted' do
        post :delete_all
        expect(flash[:notice]).to eq 'all archived posts deleted'
      end

      it 'redirect back' do
        post :delete_all
        expect(response).to redirect_to 'back'
      end
    end
  end

  describe 'POST#restore_all' do
    before do
      request.env['HTTP_REFERER'] = 'back'
      create_list(:news_link, 2, group: group)
      create_list(:group_message, 2, group: group)
      NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
    end

    context 'with logged in user' do
      login_user_from_let

      it 'restores all archived posts' do
        expect { post :restore_all }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(-4)
      end

      it 'redirects back' do
        post :restore_all
        expect(response).to redirect_to 'back'
      end
    end
  end

  describe 'PATCH#restore' do
    context 'restore social link' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        create_list(:social_link, 2, group: group)
        NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
      end

      context 'with logged in user' do
        login_user_from_let

        it 'restore archived post' do
          expect { patch :restore, id: NewsFeedLink.last.id }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(-1)
        end

        it 'redirects back' do
          patch :restore, id: NewsFeedLink.last.id
          expect(response).to redirect_to 'back'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :restore, id: NewsFeedLink.last.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { SocialLink.last }
            let(:owner) { user }
            let(:key) { 'social_link.restore' }

            before {
              perform_enqueued_jobs do
                patch :restore, id: NewsFeedLink.last.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end

    context 'restore news link' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        create_list(:news_link, 2, group: group)
        NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
      end

      context 'with logged in user' do
        login_user_from_let

        it 'restore archived post' do
          expect { patch :restore, id: NewsFeedLink.last.id }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(-1)
        end

        it 'redirects back' do
          patch :restore, id: NewsFeedLink.last.id
          expect(response).to redirect_to 'back'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :restore, id: NewsFeedLink.last.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { NewsLink.last }
            let(:owner) { user }
            let(:key) { 'news_link.restore' }

            before {
              perform_enqueued_jobs do
                patch :restore, id: NewsFeedLink.last.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end

    context 'restore group message' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        create_list(:group_message, 2, group: group)
        NewsFeedLink.all.update_all(archived_at: DateTime.now.months_ago(2))
      end

      context 'with logged in user' do
        login_user_from_let

        it 'restore archived post' do
          expect { patch :restore, id: NewsFeedLink.last.id }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(-1)
        end

        it 'redirects back' do
          patch :restore, id: NewsFeedLink.last.id
          expect(response).to redirect_to 'back'
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect {
                patch :restore, id: NewsFeedLink.last.id
              }.to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { GroupMessage.last }
            let(:owner) { user }
            let(:key) { 'group_message.restore' }

            before {
              perform_enqueued_jobs do
                patch :restore, id: NewsFeedLink.last.id
              end
            }

            include_examples 'correct public activity'
          end
        end
      end
    end
  end
end
