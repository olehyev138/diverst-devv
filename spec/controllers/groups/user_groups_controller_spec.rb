require 'rails_helper'

RSpec.describe Groups::UserGroupsController, type: :controller do
  describe "PATCH#update" do
    context "with logged user" do
      let(:group){ create(:group) }
      let(:user){ create(:user) }
      let!(:user_group){ create(:user_group, user: user, group: group, notifications_frequency: UserGroup.notifications_frequencies[:disabled]) }


      describe 'when exists the user_group' do
        describe 'when user is logged in' do
          login_user_from_let

          context 'with valid attributes' do
            before { patch :update, group_id: group.id, id: user_group.id, user_group: { notifications_frequency: "weekly", notifications_date: "monday" }, format: :json }

            it 'returns response in json' do
              expect(response.content_type).to eq 'application/json'
            end

            it 'updates the enable_notification of a user_group' do
              user_group.reload
              expect(assigns[:user_group].notifications_frequency).to eq 'weekly'
              expect(assigns[:user_group].notifications_date).to eq 'monday'
            end

            it 'return a sucessful response' do
              expect(response.status).to eq 200
            end
          end
          
          context 'with invalid attributes' do
            before {
              allow_any_instance_of(UserGroup).to receive(:update).and_return(false)
              patch :update, group_id: group.id, id: user_group.id, user_group: { notifications_frequency: "hourly" 
              }, format: :json }

            it 'returns response in json' do
              expect(response.content_type).to eq 'application/json'
            end

            it 'updates the enable_notification of a user_group' do
              user_group.reload
              expect(assigns[:user_group].notifications_frequency).to_not eq 'hourly'
            end

            it 'return a sucessful response' do
              expect(response.status).to eq 422
            end
          end
        end

        describe 'when is not logged in' do
          before { patch :update, group_id: group.id, id: user_group.id, user_group: { notifications_frequency: "hourly" }, format: :json }
          it_behaves_like "redirect user to users/sign_in path"
        end
      end
    end
  end
end
