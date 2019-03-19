require 'rails_helper'

RSpec.describe IntegrationsHelper do 
	let!(:enterprise) { create(:enterprise) }

	describe '#events_calendar_iframe_code' do  
		it 'returns an iframe containing url' do 
			url = integrations_calendar_url(enterprise.iframe_calendar_token)
			expect(events_calendar_iframe_code(enterprise)).to eq "<iframe src='#{url}'></iframe>"
		end
	end
end