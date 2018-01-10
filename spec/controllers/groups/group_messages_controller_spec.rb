require 'rails_helper'

RSpec.describe Groups::GroupMessagesController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    let(:group_message){ create(:group_message, group: group, subject: "Test", owner: user) }


    describe 'GET#index' do
        context 'when user is looged in' do
            login_user_from_let
            let(:group_message1) { create(:group_message, group: group, subject: "Test", owner: user, created_at: Time.now - 2.hours) }
            before { get :index, group_id: group.id }

            it "render index template" do
                expect(response).to render_template :index
            end

            it 'gets a valid group object' do
                expect(assigns[:group]).to be_valid
            end

            it 'returns messages belonging to group object in descending order of created_at' do
                expect(assigns[:group].messages).to eq [group_message, group_message1]
            end
        end

        context 'when users is not logged in' do
            before { get :index, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET#show' do
        context 'when user is logged in' do
            login_user_from_let
            let!(:comments) { create_list(:group_message_comment, 2, message: group_message, author: user) }
            before { get :show, group_id: group.id, id: group_message.id }

            it "renders show template" do
                expect(response).to render_template :show
            end

            it 'returns comments belonging to message object' do
                expect(assigns[:message].comments).to eq comments
            end

            it 'returns new GroupMessageComment object' do
                expect(assigns[:new_comment]).to be_a_new(GroupMessageComment)
            end
        end

        context 'when users is not logged in' do
            before { get :show, group_id: group.id, id: group_message.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'GET#new' do
        context 'when user is logged in' do
            login_user_from_let
            before { get :new, group_id: group.id }

            it "render new template" do
                expect(response).to render_template :new
            end

            it 'returns a new message belong to valid group object' do
                expect(assigns[:message]).to be_a_new(GroupMessage)
                expect(assigns[:message].group).to eq group
            end
        end

        context 'when users is not logged in' do
            before { get :new, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET#edit' do
        context 'when user is logged in' do
            login_user_from_let
            before { get :edit, group_id: group.id, id: group_message.id }

            it "render edit template" do
                expect(response).to render_template :edit
            end

            it 'returns a valid message object' do
                expect(assigns[:message]).to be_valid
            end
        end

        context 'when users is not logged in' do
            before { get :edit, group_id: group.id, id: group_message.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'POST#create' do
        describe 'when user is logged in' do
            login_user_from_let

            context 'with valid attributes' do
                let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "message_post", points: 20) }

                it 'creates and save message object' do
                    expect{post :create, group_id: group.id, group_message: attributes_for(:group_message)}
                    .to change(GroupMessage, :count).by(1)
                end

                it "rewards a user with points of this action" do
                    expect(user.points).to eq 0

                    post :create, group_id: group.id, group_message: attributes_for(:group_message)

                    user.reload
                    expect(user.points).to eq 20
                end

                it 'flashes a reward message' do
                    user.enterprise.update(enable_rewards: true)
                    post :create, group_id: group.id, group_message: attributes_for(:group_message)
                    user.reload
                    expect(flash[:reward]).to eq "Your message was created. Now you have #{user.credits} points"
                end

                it 'redirects to group_posts_path' do
                    post :create, group_id: group.id, group_message: attributes_for(:group_message)
                    expect(response).to redirect_to group_posts_path(group)
                end
            end

            context 'with invalid attributes' do
                invalid_attributes = FactoryGirl.attributes_for(:group_message)
                let!(:invalid_attributes) { invalid_attributes[:content] = nil }

                it 'does not create and save message object' do
                    expect{post :create, group_id: group.id, group_message: invalid_attributes}
                    .to change(GroupMessage, :count).by(0)
                end

                it 'flashes an alert message' do
                    post :create, group_id: group.id, group_message: invalid_attributes
                    expect(flash[:alert]).to eq "Your message was not created. Please fix the errors"
                end

                it 'renders a new template' do
                    post :create, group_id: group.id, group_message: invalid_attributes
                    expect(response).to render_template :new
                end
            end
        end

        describe 'when user is not logged in' do
            before { post :create, group_id: group.id, group_message: attributes_for(:group_message) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'PATCH#update' do
        describe 'when user is logged in' do
            login_user_from_let

            context "when user is not the owner of message" do
                let!(:group_message){ create(:group_message, group: group, subject: "Test") }

                before do
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

                context 'with invalid attributues' do
                    invalid_attributes = FactoryGirl.attributes_for(:group_message)
                    let!(:invalid_attributes) { invalid_attributes[:content] = nil }

                    before { patch :update, group_id: group.id, id: group_message.id, group_message: invalid_attributes }

                    it 'renders edit template' do
                        expect(response).to render_template :edit
                    end

                    it "flashes an alert message" do
                        expect(flash[:alert]).to eq("Your message was not updated. Please fix the errors")
                    end
                end
            end
        end
    end


    describe 'DELETE#destroy' do
        let!(:group_message){ create(:group_message, group: group) }
        let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "message_post", points: 90) }
        before do
            request.env["HTTP_REFERER"] = "back"
            Rewards::Points::Manager.new(user, reward_action.key).add_points(group_message)
        end

        context 'when user is logged in' do
            login_user_from_let

            it "remove reward points of a user with points of this action" do
                expect(user.points).to eq 90

                delete :destroy, group_id: group.id, id: group_message.id

                user.reload
                expect(user.points).to eq 0
            end

            it 'deletes message object' do
                expect{delete :destroy, group_id: group.id, id: group_message.id}
                .to change(GroupMessage, :count).by(-1)
            end

            it 'flashes a notice message' do
                delete :destroy, group_id: group.id, id: group_message.id
                user.reload
                expect(flash[:notice]).to eq "Your message was removed. Now you have #{user.credits} points"
            end

            it 'redirect to group_posts_path' do
                delete :destroy, group_id: group.id, id: group_message.id
                expect(response).to redirect_to group_posts_path(group)
            end
        end

        context 'when user is not logged in' do
            before { delete :destroy, group_id: group.id, id: group_message.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'POST#create_comment' do
        describe 'with user logged in' do
            login_user_from_let

            context "when successful" do
                before do
                    user.enterprise.update(enable_rewards: true)
                    post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: {content: "content"}
                end

                it "redirects" do
                    expect(response).to redirect_to group_group_message_path(group, group_message)
                end

                it "flashes a reward message" do
                    user.reload
                    expect(flash[:reward]).to eq "Your comment was created. Now you have #{user.credits} points"
                end

                it "creates the comment" do
                    group_message.reload
                    expect(group_message.comments.count).to eq(1)
                end
            end

            context "when unsuccessful" do
                before {
                    allow_any_instance_of(GroupMessageComment).to receive(:save).and_return(false)
                    post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: {content: "content"}
                }

                it "redirects" do
                    expect(response).to redirect_to group_group_message_path(group, group_message)
                end

                it "flashes an alert message" do
                    expect(flash[:alert]).to eq("Comment not saved. Please fix errors")
                end

                it "does not create the comment" do
                    group_message.reload
                    expect(group_message.comments.count).to eq(0)
                end

                context 'with invalid attributes' do
                    invalid_attributes = FactoryGirl.attributes_for(:group_message_comment)
                    let!(:invalid_attributes) { invalid_attributes[:content] = nil }

                    it 'flashes an alert message' do
                        post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: invalid_attributes
                        expect(flash[:alert]).to eq "Comment not saved. Please fix errors"
                    end
                end
            end
        end

        describe 'when user is not logged in' do
            before { post :create_comment, group_id: group.id, group_message_id: group_message.id, group_message_comment: attributes_for(:group_message) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
