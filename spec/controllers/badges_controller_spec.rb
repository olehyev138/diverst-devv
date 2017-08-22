require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:enterprise){ create(:enterprise) }
  let(:user){ create(:user, enterprise: enterprise) }
  
  describe "POST#new" do
    describe "with logged in user" do
      login_user_from_let
        it "returns success" do
          post :new
          expect(response).to be_success
        end
    end
  end

  describe "POST#create" do
    describe "with logged in user" do
      login_user_from_let

      context "with valid parameters" do
        it "creates a new badge" do
          expect{ post :create, badge: attributes_for(:badge_params) }
            .to change(enterprise.badges, :count).by(1)
        end

        it "redirects to action index" do
          post :create, badge: attributes_for(:badge_params)
          expect(response).to redirect_to rewards_path
        end
        
        it "flashes notice" do
          expect(flash[:notice])
        end
      end

      context "with invalid parameters" do
        it "does not create a new badge" do
          expect{ post :create, badge: attributes_for(:badge_params, label: "") }
            .to_not change(enterprise.badges, :count)
        end

        it "renders action new" do
          post :create, badge: attributes_for(:badge_params, label: "")
          expect(response).to render_template :new
        end
        
        it "flashes alert" do
          expect(flash[:alert])
        end
      end
    end
  end
  
  describe "GET#edit" do
    let(:badge){ create(:badge, enterprise: enterprise, points: 10) }

    describe "with logged in user" do
      login_user_from_let

      context "with valid id" do
        before(:each){ get :edit, id: badge.id}

        it "returns success" do
          expect(response).to be_success
        end
      end
      
      context "with invalid id" do
        it "returns error" do
          expect{ get :edit, id: 9999999}.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe "PATCH#update" do
    let(:badge){ create(:badge, enterprise: enterprise, points: 10) }

    describe "with logged in user" do
      login_user_from_let

      context "with valid parameters" do
        before(:each){ patch :update, id: badge.id, badge: attributes_for(:badge, points: 20) }

        it "updates the badge" do
          badge.reload
          expect(badge.points).to eq 20
        end

        it "redirects to action index" do
          expect(response).to redirect_to rewards_path
        end
        
        it "flashes notice" do 
          expect(flash[:notice])
        end
      end

      context "with invalid parameters" do
        before(:each){ patch :update, id: badge.id, badge: attributes_for(:badge, points: "") }

        it "does not update the badge" do
          badge.reload
          expect(badge.points).to eq 10
        end

        it "renders action edit" do
          expect(response).to render_template :edit
        end
        
        it "flashes alert" do
          expect(flash[:alert])
        end
      end
    end
  end

  describe "DELETE#destroy" do
    describe "with logged in user" do
      login_user_from_let
      let!(:badge){ create(:badge, enterprise: enterprise) }

      it "destroy the badge" do
        expect{ delete :destroy, id: badge.id }.to change(enterprise.badges, :count).by(-1)
      end

      it "redirects to action index" do
        delete :destroy, id: badge.id
        expect(response).to redirect_to rewards_path
      end
      
      it "flashes notice" do
        expect(flash[:notice])
      end
    end
  end
end
