require 'rails_helper'

RSpec.describe Groups::SocialLinksController, type: :controller do
    let(:user) { create :user }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let!(:social_link) { create(:social_link, author: user, group: group) }


    describe 'GET#index' do
        before do
            allow(SocialMedia::Importer).to receive(:valid_url?).and_return(true)
        end
        context 'with logged in user' do
            login_user_from_let
            before { get :index, group_id: group.id }

            it 'returns social links belonging to group object' do
                byebug
            end

            it 'renders index template' do
                expect(response).to render_template :index
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
        before :each do
            post :create, group_id: group.id, social_link: attributes_for(:social_link, :url => "https://twitter.com/realDonaldTrump/status/912848241535971331")
        end

        it "redirect back" do
            expect(response).to redirect_to group_posts_path(group)
        end
    end

    describe 'DELETE#destroy' do
        let!(:social_link){ create(:social_link, group: group) }

        before :each do
            delete :destroy, group_id: group.id, id: social_link.id
        end

        it "redirects back" do
            expect(response).to redirect_to group_posts_path(group)
        end
    end
end
