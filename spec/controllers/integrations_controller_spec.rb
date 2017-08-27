require 'rails_helper'

RSpec.describe IntegrationsController, type: :controller do
    let(:enterprise) {create :enterprise, iframe_calendar_token: "token"}
    let(:user) { create :user }
    
    describe 'GET #calendar' do
        login_user_from_let
        
        before { get :calendar, token: enterprise.iframe_calendar_token}
        
        it 'render template' do
            expect(response).to render_template "shared/calendar/calendar_view"
        end
    end
end