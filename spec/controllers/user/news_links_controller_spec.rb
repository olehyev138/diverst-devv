require 'rails_helper'

RSpec.describe User::NewsLinksController, type: :controller do
    let(:user) { create :user}

    describe 'GET #index' do
       describe  "when user is logged in" do 
         login_user_from_let

         before { get :index }

         it "renders index template" do 
            expect(response).to render_template :index
         end

         it "debug" do 
         end
       end

       describe "when user is not logged in" do
         before { get :index }
         it_behaves_like "redirect user to users/sign_in path"
       end
    end
end
