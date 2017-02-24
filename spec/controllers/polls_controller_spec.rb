require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  let(:user){ create(:user) }
  login_user_from_let

  describe "POST#create" do
    context "with logged user" do
      context "with valid params" do
        let(:poll){ attributes_for(:poll) }
        enable_public_activity

        it "creates a new poll" do
          expect{ post :create, poll: poll }.to change(Poll.where(owner_id: user.id), :count).by(1)
        end

        it "send a notification of poll" do
          expect_any_instance_of(Notifiers::PollNotifier).to receive("notify!")
          post :create, poll: poll
        end

        it "track activity of poll" do
          expect{ post :create, poll: poll }.to change(PublicActivity::Activity
            .where(owner_id: user.id, recipient_id: user.enterprise.id, trackable_type:
            "Poll", key: "poll.create"), :count).by(1)
        end

        it "redirects to index action" do
          post :create, poll: poll
          expect(response).to redirect_to action: :index
        end
      end

      context "with invalid params" do
        let(:poll){ attributes_for(:poll, status: nil) }

        it "does not create a new poll" do
          expect{ post :create, poll: poll }.to change(Poll, :count).by(0)
        end

        it "renders the new action" do
          post :create, poll: poll
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PATCH#update" do
    context "with logged user" do
      let(:poll){ create(:poll, status: 0, enterprise: user.enterprise, groups: []) }
      let(:group){ create(:group, enterprise: user.enterprise) }
      enable_public_activity

      context "with valid params" do
        before(:each) do
          patch :update, id: poll.id, poll: { group_ids: [group.id] }
        end

        it "updates the poll" do
          poll.reload
          expect(poll.groups).to eq [group]
        end

        it "send a notification of poll" do
          expect_any_instance_of(Notifiers::PollNotifier).to receive("notify!")
          patch :update, id: poll.id, poll: { group_ids: [group.id] }
        end

        it "track activity of poll" do
          expect{ patch :update, id: poll.id, poll: { group_ids: [group.id] } }
            .to change(PublicActivity::Activity.where(
              owner_id: user.id, recipient_id: user.enterprise.id, trackable_type:
              "Poll", trackable_id: poll.id, key: "poll.update"),
            :count).by(1)
        end

        it "redirects to the updated poll" do
          expect(response).to redirect_to(poll)
        end
      end

      context "with invalid params" do
        let(:group){ create(:group) }
        before(:each) do
          patch :update, id: poll.id, poll: { group_ids: [group.id] }
        end

        it "does not update the poll" do
          poll.reload
          expect(poll.groups).to eq []
        end

        it "renders the edit action" do
          expect(response).to render_template :edit
        end
      end
    end
  end
end
