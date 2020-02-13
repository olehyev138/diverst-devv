require 'rails_helper'

RSpec.describe IntegrationsController, type: :controller do
  let(:enterprise) { create :enterprise, iframe_calendar_token: 'token' }
  let(:user) { create :user }
  let!(:groups) do
    2.times { create(:group, enterprise: enterprise) }
  end
  let!(:segments) do
    3.times { create(:segment, enterprise: enterprise) }
  end

  describe 'GET #calendar' do
    login_user_from_let

    before { get :calendar, token: enterprise.get_iframe_calendar_token }

    it 'returns valid enterprise groups' do
      expect(assigns[:groups].count).to eq groups
    end

    it 'returns valid enterprise segments' do
      expect(assigns[:segments].count).to eq 3
    end

    it 'render template' do
      expect(response).to render_template 'shared/calendar/calendar_view'
    end
  end
end
