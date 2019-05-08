require 'rails_helper'

RSpec.describe ViewsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }

  describe 'POST#track' do
    context 'when user is logged in' do
      login_user_from_let

      it 'increments the view count' do
        post :track, view: { user_id: user.id, enterprise_id: user.enterprise_id, group_id: group.id }
        group.reload

        expect(group.total_views).to eq(1)
      end

      describe 'public activity' do
        enable_public_activity

        it 'creates public activity record' do
          perform_enqueued_jobs do
            expect { post :track, view: { user_id: user.id, enterprise_id: user.enterprise_id, group_id: group.id } }
            .to change(PublicActivity::Activity, :count).by(1)
          end
        end

        describe 'activity record' do
          let(:model) { View.last }
          let(:owner) { user }
          let(:key) { 'view.track' }

          before {
            perform_enqueued_jobs do
              post :track, view: { user_id: user.id, enterprise_id: user.enterprise_id, group_id: group.id }
            end
          }

          include_examples 'correct public activity'
        end
      end
    end

    context 'when user is not logged in' do
      before { post :track, view: { user_id: user.id, enterprise_id: user.enterprise_id, group_id: group.id } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
