require 'rails_helper'

RSpec.describe Groups::NewsLinksController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    
    login_user_from_let

    describe 'GET #index' do
        def get_index(group_id)
            get :index, group_id: group_id
        end

        let!(:news_link) { create(:news_link, group: group) }
        let!(:foregin_news_link) { create(:news_link) }

        context 'with logged user' do
            login_user_from_let

            before { get_index(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end

            it 'assigns correct newslinks' do
                news_links = assigns(:news_links)

                expect(news_links).to include news_link
                expect(news_links).to_not include foregin_news_link
            end
        end

        context 'without logged user' do
            before { get_index(group.to_param) }

            xit 'return error' do
                expect(response).to redirect_to action: :index
            end
        end
    end
    
    describe 'GET #new' do
        def get_new(group_id)
            get :new, group_id: group_id
        end
        
        context 'with logged user' do
            login_user_from_let

            before { get_new(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end
        end

        context 'without logged user' do
            before { get_new(group.to_param) }

            xit 'return error' do
                expect(response).to redirect_to action: :index
            end
        end
    end
    
    describe 'GET #comments' do
        let!(:news_link) { create(:news_link, group: group) }
        
        def get_comments(group_id)
            get :comments, group_id: group_id, id: news_link.id
        end
        
        context 'with logged user' do
            login_user_from_let

            before { get_comments(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end
        end

        context 'without logged user' do
            before { get_comments(group.to_param) }

            xit 'return error' do
                expect(response).to redirect_to action: :index
            end
        end
    end

    describe 'POST#create' do
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 30) }

        it "rewards a user with points of this action" do
            expect(user.points).to eq 0

            post :create, group_id: group.id, news_link: attributes_for(:news_link)

            user.reload
            expect(user.points).to eq 30
        end

        it "send group notification to users" do
            expect(UserGroupInstantNotificationJob).to receive(:perform_later).with(group, news_count: 1)
            post :create, group_id: group.id, news_link: attributes_for(:news_link)
        end
    end

    describe 'POST#create_comment' do
        let!(:news_link){ create(:news_link, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_comment", points: 35) }

        it "rewards a user with points of this action" do
            expect(user.points).to eq 0

<<<<<<< HEAD
            post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link)
=======
      post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)
>>>>>>> 788b5bdb694d972254ad5739a8ed38aa494f3d2e

            user.reload
            expect(user.points).to eq 35
        end
    end

    describe 'DELETE#destroy' do
        let!(:news_link){ create(:news_link, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 90) }
        before :each do
            Rewards::Points::Manager.new(user, reward_action.key).add_points(news_link)
        end

        it "remove reward points of a user with points of this action" do
            expect(user.points).to eq 90

            delete :destroy, group_id: group.id, id: news_link.id

            user.reload
            expect(user.points).to eq 0
        end
    end
    
    describe 'PATCH#update' do
        let!(:news_link){ create(:news_link, group: group) }
        
        before { patch :update, group_id: group.id, id: news_link.id, news_link: {title: "updated"}}
        
        it "redirects" do
            expect(response).to redirect_to action: :index
        end
        
        it "flashes" do
            expect(flash[:notice])
        end
        
        it "updates the link" do
            news_link.reload
            expect(news_link.title).to eq("updated")
        end
    end
    
    describe 'GET#url_info' do
        def get_url_info(group_id)
            get :url_info, group_id: group_id
        end
        
        context 'with logged user', :skip => "Not a route found in config/routes.rb" do
            login_user_from_let

            before { get_url_info(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end
        end

        context 'without logged user' do
            before { get_url_info(group.to_param) }

            xit 'return error' do
                expect(response).to redirect_to action: :index
            end
        end
    end
end
