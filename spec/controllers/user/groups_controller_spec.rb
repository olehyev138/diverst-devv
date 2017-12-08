require 'rails_helper'

RSpec.describe User::GroupsController, type: :controller do
    let!(:user) { create :user}
    let!(:group){ create(:group, enterprise: user.enterprise) }

    

    describe 'GET #index' do
        describe "when user is logged in" do 
            login_user_from_let
            before { get :index }

            it "render index template" do
                expect(response).to render_template :index
            end

            it "return current user's enterprise groups" do 
                expect(assigns[:current_user].enterprise.groups).to eq [group]
            end
        end

        describe "when user is not logged in" do 
            before { get :index }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET #join' do
        describe "when user is logged in" do 
            login_user_from_let
            before do 
                params = { id: group.id }
                get :join, params 
            end

            it "join group" do 
                expect(assigns[:group].members).to eq [user]
            end
        end

        describe "when user is not logged in" do 
            before do 
                params = { id: group.id }
                get :join, params 
            end
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
