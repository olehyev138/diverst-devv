require 'rails_helper'

RSpec.describe Enterprises::EventsController, type: :controller do
  describe "GET#public_calendar_data" do
    let!(:enterprise){ create(:enterprise) }
    let!(:group){ create(:group, enterprise: enterprise) }
    let!(:outcome){ create(:outcome, group: group) }
    let!(:pillar){ create(:pillar, outcome: outcome) }
    let!(:initiative){ create(:initiative, owner_group_id: group.id, pillar: pillar) }

    it "assigns events of an enterprise to @events" do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      expect(assigns(:events)).to eq [initiative]
    end
  end
end
