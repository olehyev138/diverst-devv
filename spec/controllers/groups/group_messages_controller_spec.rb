require 'rails_helper'

RSpec.describe Groups::GroupMessagesController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:group_message){ create(:group_message, group: group, subject: "Test", owner: user) }
    
    login_user_from_let
    
    describe 'GET#index' do
        it "gets the group messages" do
            get :index, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#show' do
        it "gets the group message" do
            get :show, group_id: group.id, id: group_message.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#new' do
        it "gets a new group message" do
            get :new, group_id: group.id
            expect(response).to be_success
        end
    end
    
    describe 'GET#edit' do
        it "edits group message" do
            get :edit, group_id: group.id, id: group_message.id
            expect(response).to be_success
        end
    end

    describe 'POST#create' do
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "message_post", points: 20) }

        it "rewards a user with points of this action" do
            expect(user.points).to eq 0

            post :create, group_id: group.id, group_message: attributes_for(:group_message)

            user.reload
            expect(user.points).to eq 20
        end

        it "send group notification to users" do
            expect(UserGroupInstantNotificationJob).to receive(:perform_later).with(group, messages_count: 1)
            post :create, group_id: group.id, group_message: attributes_for(:group_message)
        end
    end

    describe 'POST#create_comment' do
        let!(:group_message){ create(:group_message, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "message_comment", points: 25) }

        it "rewards a user with points of this action" do
            expect(user.points).to eq 0

            post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: attributes_for(:group_message)

            user.reload
            expect(user.points).to eq 25
        end
    end

    describe 'PATCH#update' do
        context "when user is not the owner of message" do
            let!(:group_message){ create(:group_message, group: group, subject: "Test") }
            before(:each) do
                patch :update, group_id: group.id, id: group_message.id, group_message: { subject: 'Test2' }
            end

            it "does not update the message" do
                group_message.reload
                expect(group_message.subject).to eq 'Test'
            end
        end

        context "when user is owner of message" do
            let!(:group_message){ create(:group_message, group: group, subject: "Test", owner: user) }

            context "with correct attributes" do
                before(:each) do
                    patch :update, group_id: group.id, id: group_message.id, group_message: { subject: 'Test2' }
                end

                it "updates the message" do
                    group_message.reload
                    expect(group_message.subject).to eq 'Test2'
                end

                it "redirect to index action" do
                    expect(response).to redirect_to group_posts_path(group)
                end
            end
        end
    end

    describe 'DELETE#destroy' do
        let!(:group_message){ create(:group_message, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "message_post", points: 90) }
        before :each do
            request.env["HTTP_REFERER"] = "back"
            Rewards::Points::Manager.new(user, reward_action.key).add_points(group_message)
        end

        it "remove reward points of a user with points of this action" do
            expect(user.points).to eq 90

            delete :destroy, group_id: group.id, id: group_message.id

            user.reload
            expect(user.points).to eq 0
        end
    end
    
    describe 'POST#create_comment' do
        
        before {post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: {content: "content"}}
        
        it "redirects" do
            expect(response).to redirect_to group_group_message_path(group, group_message)
        end
        
        it "flashes" do
            expect(flash[:reward])
        end
        
        it "creates the comment" do
            group_message.reload
            expect(group_message.comments.count).to eq(1)
        end
    end
end
