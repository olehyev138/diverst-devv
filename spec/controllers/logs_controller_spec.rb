require 'rails_helper'

RSpec.describe LogsController, type: :controller do
  describe 'GET #index' do
    def get_index
      get :index
    end

    context 'with logged user' do
      let(:user) { create :user }
      let(:enterprise1) { user.enterprise }
      let(:enterprise2) { create :enterprise }

      let(:initiative1) { create :initiative }
      let(:initiative2) { create :initiative }

      let!(:activity1) {
        PublicActivity::Activity.create(
          trackable_id: initiative1.id,
          trackable_type: initiative1.class.to_s,
          key: 'initiative.create',
          recipient: enterprise1
        )
      }
      let!(:activity2) {
        PublicActivity::Activity.create(
          trackable_id: initiative2.id,
          trackable_type: initiative2.class.to_s,
          key: 'initiative.create',
          recipient: enterprise2
        )
      }
      login_user_from_let

      before { get_index }

      it 'returns success' do
        expect(response).to be_success
      end

      describe 'enterprise' do
        it 'only shows records from current enterprise' do
          activities = assigns(:activities)

          expect(activities).to include activity1
          expect(activities).to_not include activity2
        end
      end
    end

    context 'without logged user' do
      before { get_index }

      it 'returns error' do
        expect(response).to_not be_success
      end
    end
  end
end