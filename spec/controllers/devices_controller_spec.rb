require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
    let(:user){ create(:user) }
    
    describe "GET#index" do
        describe "with logged in user" do

            login_user_from_let

            it "gets the user devices" do
                get :index
                expect(response.status).to eq(401)
            end
        end
    end
end