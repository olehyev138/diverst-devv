require 'rails_helper'

RSpec.describe Api::V1::NewsFeedsController, :type => :controller do
    
    let(:api_key) { FactoryGirl.create(:api_key) }
    let(:enterprise) {FactoryGirl.create(:enterprise)}
    let(:user) { FactoryGirl.create(:user, :enterprise => enterprise) }
    let(:group) { FactoryGirl.create(:group, :enterprise => enterprise) }
    let(:news_feed) { FactoryGirl.create(:news_feed, :group => group) }
    let(:jwt) { UserTokenService.create_jwt(user) }
    let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt} }

    before :each do
        request.headers.merge!(valid_session) # Add to request headers
    end
    
    describe "GET #index" do
        context "gets the news_feeds" do
            before do
                get :index, params: {}
            end
            it "responds with success" do
                expect(response).to have_http_status(:success)
            end
        end
    end
    
    describe "POST #create" do
        context "creates a news_feed" do
            before do
                group2 = create(:group, :enterprise => enterprise)
                payload = {
                    group_id: group2.id
                }
                post :create, params: {news_feed: payload}
            end
            it "responds with success" do
                expect(response).to have_http_status(:success)
            end
        end
    end
    
    describe "PUT #update" do
        context "updates a news_feed" do
            before do
                group2 = create(:group, :enterprise => enterprise)
                put :update, params: {id: news_feed.id, news_feed: {group_id: group2.id}}
            end
            it "responds with success" do
                expect(response).to have_http_status(:success)
            end
        end
    end
    
    describe "DELETE #destroy" do
        context "deletes a news_feed" do
            before do
                delete :destroy, params: {id: news_feed.id}
            end
            it "responds with success" do
                expect(response).to have_http_status(:success)
            end
        end
    end
    
end