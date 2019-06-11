require 'rails_helper'

RSpec.describe DiverstController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:api_key) { FactoryBot.create(:api_key) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:missing_version_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:invalid_version_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:missing_api_session) { {} }
  let(:invalid_api_session) { { 'Diverst-APIKey' => 'fakekey', 'Diverst-UserToken' => jwt } }
  let(:missing_token_session) { { 'Diverst-APIKey' => api_key.key } }
  let(:invalid_token_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => 'faketoken' } }

  controller do
    def index
    end
  end

  context 'handling rescue_from' do
    before :each do
      request.headers.merge!(valid_session) # Add to request headers
    end

    errors = OpenStruct.new({ full_messages: ['test'] })
    resource = OpenStruct.new({ errors: errors })
    errors = [
      { name: ActiveRecord::RecordInvalid, status: 400 },
      { name: ActiveRecord::RecordNotFound, status: 404 },
      { name: BadRequestException, status: 400 },
      { name: InvalidInputException.new('Invalid Password', 'password'), status: 422, message: 'Invalid Password' },
      { name: UnprocessableException, status: 422, message: OpenStruct.new(resource) },
      { name: ActionController::ParameterMissing, status: 400, message: 'Test' },
      { name: ActionController::UnpermittedParameters, status: 400, message: [] },
      { name: Rack::Timeout::RequestTimeoutException, status: 408, message: 'Test' },
      { name: Rack::Timeout::RequestExpiryError, status: 408, message: 'Test' },
      { name: Rack::Timeout::RequestTimeoutError, status: 408, message: 'Test' },
      { name: ActiveRecord::StatementInvalid, status: 400 },
      { name: ActiveModel::UnknownAttributeError.new(nil, nil), status: 400 }
    ]
    errors.each do |error|
      it "raises an #{error[:name]} and returns #{error[:status]}" do
        allow(controller).to receive(:index).and_raise(error[:name], error[:message])
        get :index, params: nil
        expect(response).to have_http_status(error[:status])
      end
    end
  end

  describe '#verify_jwt_token' do
    context 'no token' do
      before :each do
        request.headers.merge!(missing_token_session) # Add to request headers
      end
      it 'renders error' do
        get :index, params: nil
        expect(response).to have_http_status(401)
      end
    end
    context 'with invalid token' do
      before :each do
        request.headers.merge!(invalid_token_session) # Add to request headers
      end
      it 'renders error' do
        get :index, params: nil
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#verify_api_key' do
    context 'no api key' do
      before :each do
        request.headers.merge!(missing_api_session) # Add to request headers
      end
      it 'renders error' do
        get :index, params: nil
        expect(response).to have_http_status(403)
      end
    end
    context 'with invalid api key' do
      before :each do
        request.headers.merge!(invalid_api_session) # Add to request headers
      end
      it 'renders error' do
        get :index, params: nil
        expect(response).to have_http_status(403)
      end
    end
  end
end
