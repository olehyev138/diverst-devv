require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    include ActiveJob::TestHelper

    let(:user) { create :user }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let!(:news_feed_link1) { create(:news_feed_link, link: news_link1, approved: true, created_at: Time.now - 5.hours) }
    let!(:news_feed_link2) { create(:news_feed_link, link: news_link2, approved: true, created_at: Time.now - 2.hours) }
    let!(:news_feed_link3) { create(:news_feed_link, link: news_link3, approved: true, created_at: Time.now) }
    let!(:news_link1) { create(:news_link, :group => group)}
    let!(:news_link2) { create(:news_link, :group => group)}
    let!(:news_link3) { create(:news_link, :group => group)}
   

    describe 'GET #index' do
        context 'with user logged in' do
            login_user_from_let
            before { get :index, group_id: group.id }

            it 'render index template' do
                expect(response).to render_template :index
            end

            it 'debug' do 
                byebug
            end
        end
    end

    describe 'GET #pending' do
        it 'return success' do
            get :pending, group_id: group.id
            expect(response).to be_success
        end
    end

    describe 'PATCH #approve' do
        before :each do
            # ensure the job is performed and that
            # we don't receive any errors
            perform_enqueued_jobs do
                request.env["HTTP_REFERER"] = "back"
                patch :approve, group_id: group.id, link_id: news_link.news_feed_link.id
            end
        end

        it 'return success' do
            expect(response).to redirect_to "back"
        end
    end
end
