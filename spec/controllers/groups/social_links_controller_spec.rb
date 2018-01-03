require 'rails_helper'

RSpec.describe Groups::SocialLinksController, type: :controller do
    let(:enterprise) { create(:enterprise, enable_rewards: true) }
    let(:user) { create :user, enterprise: enterprise }
    let(:group) { create(:group, enterprise: user.enterprise) }


    describe 'GET#index' do
        before do
            allow(SocialMedia::Importer).to receive(:valid_url?).with("https://www.instagram.com/p/tsxp1hhQTG/").and_return(true)
        end
        let!(:social_links) { create_list(:social_link, 2, author: user, group: group) }

        context 'with logged in user' do
            login_user_from_let
            before { get :index, group_id: group.id }

            it 'returns social links belonging to group object' do
                expect(assigns[:group].social_links).to eq social_links
            end

            it 'renders index template' do
                expect(response).to render_template :index
            end
        end

        context 'with user not logged in' do 
            before { get :index, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
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

            it 'return new group social link object' do
                expect(assigns[:social_link]).to be_a_new(SocialLink)
            end
        end

        context 'with user not logged in' do
            before { get_new(group.to_param) }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'POST#create' do
        describe 'with logged in user' do
            login_user_from_let
            let!(:reward_action) { create(:reward_action, enterprise: user.enterprise, key: "social_media_posts", points: 75) }

            context 'with valid params' do

                it 'creates a social link object' do 
                    expect{post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331")}
                    .to change(SocialLink, :count).by(1)
                end

                it "redirect back" do
                    post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331")
                    expect(response).to redirect_to group_posts_path(group)
                end

                it 'rewards a user with points of this action' do
                    expect(user.points).to eq 0
                    post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331")
                    user.reload
                    expect(user.points).to eq 75
                end

                it 'flashes a reward message' do
                    post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331")
                    user.reload
                    expect(flash[:reward]).to eq "Your social_link was created. Now you have #{ user.credits } points"
                end
            end

            context 'with invalid params' do
                before { request.env["HTTP_REFERER"] = "back" }

                it 'does not create social link object' do 
                    expect{post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://example.com/912848")}
                    .to change(SocialLink, :count).by(0)
                end

                it 'flashes an alert message' do
                    post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://example.com/912848")
                    expect(flash[:alert]).to eq "Your social link was not created. Please fix the errors"
                end

                it 'redirects to back' do
                    post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://example.com/912848")
                    expect(response).to redirect_to "back"
                end
            end
        end


        describe "with a user not logged in" do
            before { post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331") }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'DELETE#destroy' do
        describe 'with user logged in' do
            login_user_from_let
            let!(:social_link){ create(:social_link, group: group, url: "https://twitter.com/realDonaldTrump/status/912848241535971331") }

            it 'destroys social link object' do 
                expect{delete :destroy, group_id: group.id, id: social_link.id}.to change(SocialLink, :count).by(-1)
            end

            it 'flashes notice message' do 
                delete :destroy, group_id: group.id, id: social_link.id
                expect(flash[:notice]).to eq "Your social link was removed."
            end

            it "redirects back" do
                delete :destroy, group_id: group.id, id: social_link.id
                expect(response).to redirect_to group_posts_path(group)
            end
        end
    end
end
