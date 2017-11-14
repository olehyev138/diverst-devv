require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let(:match){ create(:match, user1_id: user.id, user2_id: user2.id) }

    describe "GET#index" do
        describe "with logged in user" do

            login_user_from_let

            it "gets 401" do
                get :index
                expect(response.status).to eq(401)
            end
        end
    end

    describe "DELETE#destroy" do
        describe "with logged in user" do

            login_user_from_let

            it "destroy the match" do
                delete :destroy, id: match.id
                expect(response.status).to eq(401)
            end
        end
    end

    describe "UPDATE#opt_in" do
        describe "with logged in user" do

            login_user_from_let

            it "update the match" do
                put :opt_in, id: match.id
                expect(response.status).to eq(401)
            end
        end
    end
end