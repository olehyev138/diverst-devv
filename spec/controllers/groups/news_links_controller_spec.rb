require 'rails_helper'

RSpec.describe Groups::NewsLinksController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }

    describe 'GET #index' do
        def get_index(group_id)
            get :index, group_id: group_id
        end

        let!(:news_link) { create(:news_link, group: group) }
        let!(:foreign_news_link) { create(:news_link) }

        context 'with logged user' do
            login_user_from_let

            before { get_index(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end

            it 'assigns correct newslinks' do
                news_links = assigns(:news_links)

                expect(news_links).to include news_link
                expect(news_links).to_not include foreign_news_link
            end
        end

        context 'without logged user' do
            before { get_index(group.to_param) }

            it 'redirect_to new_user_session' do
                expect(response).to redirect_to :new_user_session
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

        context 'without logged user', :skip => true do
            before { get_new(group.to_param) }

            it 'redirect_to new_user_session' do
                expect(response).to redirect_to :new_user_session
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

            it 'redirect_to new_user_session' do
                expect(response).to redirect_to :new_user_session
            end
        end
    end

    describe 'POST#create' do
        login_user_from_let
        
        context "when successful" do
            let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_post", points: 30) }
            
            it "rewards a user with points of this action" do
                expect(user.points).to eq 0
            end
            
            before{post :create, group_id: group.id, news_link: {title: "Test", url: "https://www.msn.com", description: "Test", photos_attributes: [{file: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/verizon_logo.png', 'image/png')}]}}
            
            it "rewards a user with points of this action" do
                user.reload
                expect(user.points).to eq 30
            end
            
            it "creates the news link" do
                expect(NewsLink.count).to eq(1)
            end
            
            it "creates the news link photo" do
                expect(NewsLinkPhoto.count).to eq(1)
            end
        end
        
        context "when unsuccessful" do
            it "flashes alert" do
                allow_any_instance_of(NewsLink).to receive(:save).and_return(false)
                post :create, group_id: group.id, news_link: {title: "Test", url: "https://www.msn.com", description: "Test", photos_attributes: [{file: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/verizon_logo.png', 'image/png')}]}
                
                expect(flash[:alert]).to eq "Your news was not created. Please fix the errors"
            end
        end
    end

    describe 'POST#create_comment' do
        login_user_from_let
        
        let!(:news_link){ create(:news_link, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "news_comment", points: 35) }
        
        context "when successful" do
            it "rewards a user with points of this action" do
                expect(user.points).to eq 0
    
                post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)
    
                user.reload
                expect(user.points).to eq 35
            end
        end
        
        context "when unsuccessful" do
            it "flashes alert" do
                allow_any_instance_of(NewsLinkComment).to receive(:save).and_return(false)
                post :create_comment, group_id: group.id, id: news_link, news_link_comment: attributes_for(:news_link_comment)
    
                expect(flash[:alert]).to eq "Your comment was not created. Please fix the errors"
            end
        end
    end

    describe 'DELETE#destroy' do
        login_user_from_let
        
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
        login_user_from_let
        
        let!(:news_link){ create(:news_link, group: group) }
        let!(:news_link_photo){ create(:news_link_photo, news_link: news_link, file: Rack::Test::UploadedFile.new(Rails.root + 'spec/fixtures/files/verizon_logo.png', 'image/png')) }
        
        context "when updating without changes to photos" do
            before { patch :update, group_id: group.id, id: news_link.id, news_link: {title: "updated"}}
    
            it "redirects" do
                expect(response).to redirect_to group_posts_path(group)
            end
    
            it "flashes" do
                expect(flash[:notice])
            end
    
            it "updates the link" do
                news_link.reload
                expect(news_link.title).to eq("updated")
                expect(news_link.photos.count).to eq(1)
            end
        end
        
        context "when updating with changes to photos" do
            before { patch :update, group_id: group.id, id: news_link.id, news_link: {title: "updated", photos_attributes: [{"_destroy"=> "1", "id" => news_link_photo.id}]}}
    
            it "redirects" do
                expect(response).to redirect_to group_posts_path(group)
            end
    
            it "flashes" do
                expect(flash[:notice])
            end
    
            it "updates the link and deletes the photo" do
                news_link.reload
                expect(news_link.title).to eq("updated")
                expect(news_link.photos.count).to eq(0)
            end
        end
        
        context "when unsuccessful" do
            it "flashes alert" do
                allow_any_instance_of(NewsLink).to receive(:update).and_return(false)
                patch :update, group_id: group.id, id: news_link.id, news_link: {title: "updated"}
                
                expect(flash[:alert]).to eq "Your news was not updated. Please fix the errors"
            end
        end
    end
end
