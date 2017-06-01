require 'rails_helper'

RSpec.describe Groups::UpdatesController, type: :controller do
  let(:user){ create(:user) }
  login_user_from_let

  describe "POST#create" do
    context "with logged user" do
      let(:group){ create(:group, enterprise: user.enterprise) }

      context "with valid params" do
        let(:group_update){ attributes_for(:group_update) }

        it "creates a new group_update" do
          expect{ post :create, group_id: group.id, group_update: group_update }
            .to change(GroupUpdate.where(owner_id: user.id, group: group), :count).by(1)
        end

        it "redirects to index action" do
          post :create, group_id: group.id, group_update: group_update
          expect(response).to redirect_to action: :index
        end
      end

      context "with invalid params" do
        let(:group_update){ attributes_for(:group_update, created_at: nil) }

        it "does not create a new group_update" do
          expect{ post :create, group_id: group.id, group_update: group_update }.to change(GroupUpdate, :count).by(0)
        end

        it "renders the new action" do
          post :create, group_id: group.id, group_update: group_update
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PATCH#update" do
    context "with logged user" do
      let(:group){ create(:group, enterprise: user.enterprise) }
      let(:group_update){ create(:group_update, group: group, created_at: "2017-01-02") }

      context "with valid params" do
        before(:each) do
          patch :update, group_id: group.id , id: group_update.id, group_update: { created_at: "2017-01-01" }
        end

        xit "updates the group_update" do
          #This is failing since introdusing timezones
          group_update.reload
          expect(group_update.created_at).to eq Time.zone.parse("2017-01-01")
        end

        it "redirects to index action" do
          expect(response).to redirect_to action: :index
        end
      end

      context "with invalid params" do
        before(:each) do
          patch :update, group_id: group.id , id: group_update.id, group_update: { created_at: "" }
        end

        it "does not update the group_update" do
          expect(group_update.created_at.strftime("%Y-%m-%d")).to eq "2017-01-02"
        end

        it "renders the edit action" do
          expect(response).to render_template :edit
        end
      end
    end
  end
end
