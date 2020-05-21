require 'rails_helper'

RSpec.describe Enterprises::EventsController, type: :controller do
  describe 'GET#public_calendar_data' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:outcome) { create(:outcome, group: group) }
    let!(:pillar) { create(:pillar, outcome: outcome) }
    let!(:initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar) }



    it 'assigns events of an enterprise to @events' do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      expect(assigns(:events)).to eq [initiative]
    end

    it 'returns correct calendar data in json' do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[0][:title]).to eq initiative.title
      expect(json_response[0][:start].to_datetime).to eq initiative.start
      expect(json_response[0][:end].to_datetime).to eq initiative.end
    end

    it 'renders events partial' do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      expect(response).to render_template 'shared/calendar/events'
    end

    it 'returns data in json format' do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      expect(response.content_type).to eq 'application/json'
    end

    it 'sets a valid enterprise object' do
      get :public_calendar_data, enterprise_id: enterprise.id, format: :json
      expect(assigns[:enterprise]).to be_valid
    end
  end
end
