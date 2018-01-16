require 'rails_helper'

RSpec.describe Groups::CommentsController, type: :controller do
  let(:user) { create :user }
  let(:group){ create(:group, enterprise: user.enterprise) }
  let(:initiative){ initiative_of_group(group) }


  describe 'POST#create' do
    describe 'when user is logged in' do
      login_user_from_let
      let!(:reward_action){ create(:reward_action, enterprise: user.enterprise, key: "feedback_on_event", points: 80) }
      before do 
        request.env["HTTP_REFERER"] = "back" 
        user.enterprise.update(enable_rewards: true)
      end

      context 'with valid attributes' do
        it 'creates and saves comment object' do
          expect{post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "comment" }}
          .to change(InitiativeComment, :count).by(1)
        end

        it 'flashes a reward message' do 
          post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "comment" }
          user.reload
          expect(flash[:reward]).to eq "Your comment was created. Now you have #{ user.credits } points"
        end


        it "rewards a user with points of this action" do
          expect(user.points).to eq 0

          post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "comment" }

          user.reload
          expect(user.points).to eq 80
        end

        it 'redirects to previous page' do 
          post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "comment" }
          expect(response).to redirect_to "back"
        end
      end

      context 'with invalid attributes' do
        it 'does not save comment object' do 
          expect{post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: nil }}
          .to change(InitiativeComment, :count).by(0)
        end

        it 'flashes an alert message' do 
          post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: nil }
          expect(flash[:alert]).to eq 'Your comment was not created. Please fix the errors'
        end

        it 'redirects to previous page' do 
          post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: nil }
          expect(response).to redirect_to "back"
        end
      end
    end

    describe 'when user is not logged in' do 
      before { post :create, group_id: group.id, event_id: initiative.id, initiative_comment: { content: "comment" } }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end
end
