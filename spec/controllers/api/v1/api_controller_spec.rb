require 'rails_helper'

RSpec.describe Api::V1::ApiController, type: :controller do
    let(:enterprise){ create(:enterprise) }
    let(:user){ create(:user, enterprise: enterprise, password: "password") }
    
    controller do
        def index
        end
    end
    
    describe "handling rescue_from" do

        errors = [
            {name: ActionController::UnknownFormat, status: 400},
            {name: ActionController::RoutingError, status: 400},
            {name: ActiveRecord::StatementInvalid, status: 400},
            {name: ActiveRecord::RecordNotFound, status: 400},
            {name: ActionView::MissingTemplate, status: 400},
            {name: ActionController::UrlGenerationError, status: 400},
            {name: StandardError, status: 400}
        ]
        
        errors.each do |error|
            it "raises an #{error[:name]} and returns #{error[:status]}" do
                allow(controller).to receive(:index).and_raise(error[:name])
                get :index
                expect(response).to have_http_status(error[:status])
            end
        end
    end
end