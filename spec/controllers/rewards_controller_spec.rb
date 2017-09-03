require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
    let!(:enterprise){ create(:enterprise) }
    let!(:user){ create(:user, enterprise: enterprise) }
    let(:reward){ create(:reward, enterprise: enterprise, points: 10) }
    
    describe "GET#index" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid parameters" do
                before {get :index}
                it "gets the rewards" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#new" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid parameters" do
                before {get :new}
                it "gets the new page" do
                    expect(response).to be_success
                end
            end
        end
    end
    
    describe "GET#edit" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid parameters" do
                before {get :edit, :id => reward.id}
                it "gets the edit page" do
                    expect(response).to be_success
                end
            end
        end
    end

    describe "POST#create" do
        describe "with logged in user" do
            login_user_from_let

            context "with valid parameters" do
                it "creates a new reward" do
                    expect{ post :create, reward: attributes_for(:reward).merge(responsible_id: user.id) }.to change(enterprise.rewards, :count).by(1)
                end

                it "redirects to action index" do
                    post :create, reward: attributes_for(:reward).merge(responsible_id: user.id)
                    expect(response).to redirect_to(action: :index)
                end
            end

            context "with invalid parameters" do
                it "does not create a new reward" do
                    expect{ post :create, reward: attributes_for(:reward, label: "") }.to_not change(enterprise.rewards, :count)
                end

                it "renders action new" do
                    post :create, reward: attributes_for(:reward, label: "")
                    expect(response).to render_template :new
                end
            end
        end
    end

    describe "PATCH#update" do
        let(:reward){ create(:reward, enterprise: enterprise, points: 10) }

        describe "with logged in user" do
            login_user_from_let

            context "with valid parameters" do
                before(:each){ patch :update, id: reward.id, reward: attributes_for(:reward, points: 20) }

                it "updates the reward" do
                    reward.reload
                    expect(reward.points).to eq 20
                end

                it "redirects to action index" do
                    expect(response).to redirect_to(action: :index)
                end
            end

            context "with invalid parameters" do
                before(:each){ patch :update, id: reward.id, reward: attributes_for(:reward, points: "") }

                it "does not update the reward" do
                    reward.reload
                    expect(reward.points).to eq 10
                end

                it "renders action edit" do
                    expect(response).to render_template :edit
                end
            end
        end
    end

    describe "DELETE#destroy" do
        describe "with logged in user" do
            login_user_from_let
            let!(:reward){ create(:reward, enterprise: enterprise) }

            it "destroy the reward" do
                expect{ delete :destroy, id: reward.id }.to change(enterprise.rewards, :count).by(-1)
            end

            it "redirects to action index" do
                delete :destroy, id: reward.id
                expect(response).to redirect_to(action: :index)
            end
        end
    end
end
