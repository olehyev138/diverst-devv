require 'rails_helper'

model = 'User'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let!(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}?image_size=large", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:index).and_raise(BadRequestException)
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#show' do
    it 'gets a item' do
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    it 'creates an item' do
      attributes = build(route.singularize.to_sym).attributes
      attributes['user_role_id'] = user.user_role_id
      attributes['password'] = 'password'
      post "/api/v1/#{route}", params: { "#{route.singularize}" => attributes }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'inserts a user in the database' do
      attributes = build(route.singularize.to_sym).attributes
      attributes['user_role_id'] = user.user_role_id
      attributes['password'] = 'password'
      expect { post "/api/v1/#{route}", params: { "#{route.singularize}" => attributes }, headers: headers }.to change(model.constantize, :count).by(1)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'user has been updated' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => { 'id' => item.id, 'first_name' => 'abc' } }, headers: headers
      expect(item.attributes).to_not eq model.constantize.find(item.id).attributes
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when updating', model
  end

  describe '#destroy' do
    it 'deletes an item' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it 'destroys a user in the database' do
      expect { delete "/api/v1/#{route}/#{item.id}", headers: headers }.to change(model.constantize, :count).by(-1)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#prototype' do
    it 'gets prototype' do
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:index).and_raise(BadRequestException)
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#sample_csv' do
    it 'Returns a user list csv' do
      get "/api/v1/#{route}/sample_csv", headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('text/csv')
    end
  end

  # TODO : Test response
  describe '#find_user_enterprise_by_email' do
    xit 'gets user' do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to_not be nil
    end
  end

  # TODO : Testing with tokens
  describe '#sign_up' do
    xit 'Signs the user in' do
      post "/api/v1/#{route}/sign_up", params: { "#{route.singularize}" => item }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'captures the error when BadRequestException' do
      post "/api/v1/#{route}/sign_up", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    xcontext 'when verifying the token validity' do
      it 'Invalid user token ' do
      end

      it 'Unauthorized access' do
      end
    end
  end

  # TODO : Testing with tokens
  describe '#sign_up_token' do
    xit 'Sign up token' do
      post "/api/v1/#{route}/sign_up_token", params: { "#{route.singularize}" => item }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'captures the error when BadRequestException' do
      post "/api/v1/#{route}/sign_up_token", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    xcontext 'when verifying the token validity' do
      it 'Invalid user token ' do
      end

      it 'Unauthorized access' do
      end
    end
  end
end
