require 'rails_helper'

RSpec.describe FieldsController, type: :controller do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:field) { create(:field, type: 'NumericField', container_id: enterprise.id, container_type: 'Enterprise', elasticsearch_only: false) }

  describe 'GET#stats' do
    describe 'with logged in user' do
      login_user_from_let

      it 'returns success' do
        # get :stats, :id => field.id
        # expect(response).to be_success
      end
    end
  end
end
