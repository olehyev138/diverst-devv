require 'rails_helper'

RSpec.describe "User::GroupsController", type: :controller do
    before { @controller = User::GroupsController.new }

    let!(:user) { create :user}
    let!(:group) { create(:group, enterprise: user.enterprise, owner: user) }

    describe 'GET #index' do
        describe "when user is logged in" do 
            login_user_from_let
            
            context "when group is not private" do
                before { get :index }
                
                it "render index template" do
                    expect(response).to render_template :index
                end
    
                it "return 1 of the current user's enterprise non private groups" do 
                    expect(assigns[:groups]).to eq [group]
                
                end
            end
            
            context "when group is private" do
                before { 
                    group.private = true
                    group.save!
                    get :index 
                }
                
                it "render index template" do
                    expect(response).to render_template :index
                end
    
                it "return 0 of the current user's enterprise non private groups" do 
                    expect(assigns[:groups]).to eq []
                end
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
