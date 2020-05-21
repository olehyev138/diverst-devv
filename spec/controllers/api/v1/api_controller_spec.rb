require 'rails_helper'

RSpec.describe Api::V1::ApiController, type: :controller do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, password: 'password') }

  controller do
    def index
    end
  end

  describe 'handling rescue_from' do
    before :each do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password')
    end

    errors = [
        { name: ActionController::ParameterMissing, status: 400, message: 'test' },
        { name: ActionController::RoutingError, status: 400 },
        { name: ActiveRecord::RecordNotFound, status: 400 },
        { name: ActionController::UrlGenerationError, status: 400, message: 'test' },
        { name: BadRequestException, status: 400 },
        { name: Pundit::NotAuthorizedError.new({}), status: 400 }
    ]

    errors.each do |error|
      it "raises an #{error[:name]} and returns #{error[:status]}" do
        allow(controller).to receive(:index).and_raise(error[:name], error[:message])
        get :index
        expect(response).to have_http_status(error[:status])
      end
    end
  end
end
