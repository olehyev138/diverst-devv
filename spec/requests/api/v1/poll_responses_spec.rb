require 'rails_helper'

model = 'PollResponse'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:poll) { create(:poll, enterprise: enterprise, owner_id: user.id) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}", headers: headers
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
      field = poll.fields.first
      payload = {
        anonymous: false,
        poll_id: poll.id
      }
      post "/api/v1/#{route}", params: { "#{route.singularize}" => payload, "custom-fields": { "#{field.id}": '1' }, }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      field = poll.fields.first
      payload = {
        anonymous: false,
        poll_id: poll.id
      }
      post "/api/v1/#{route}", params: { "#{route.singularize}" => payload, "custom-fields": { "#{field.id}": '1' }, }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the error when InvalidInputException' do
      allow_any_instance_of(model.constantize).to receive(:save).and_return(false)
      allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :full_messages) { [] }
      allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :messages) { [[]] }
      field = poll.fields.first
      payload = {
        anonymous: false,
        poll_id: poll.id
      }
      post "/api/v1/#{route}", params: { "#{route.singularize}" => payload, "custom-fields": { "#{field.id}": '1' }, }, headers: headers
      expect(response).to have_http_status(422)
    end
  end

  describe '#update' do
    it 'updates an item' do
      field = poll.fields.first
      payload = {
        anonymous: false,
        poll_id: poll.id
      }

      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => payload, "custom-fields": { "#{field.id}": '1' } }, headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it 'captures the error when InvalidInputException' do
      allow_any_instance_of(model.constantize).to receive(:save).and_return(false)
      allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :full_messages) { [] }
      allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :messages) { [[]] }
      field = poll.fields.first
      payload = {
        anonymous: false,
        poll_id: poll.id
      }

      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => payload, "custom-fields": { "#{field.id}": '1' } }, headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#destroy' do
    it 'deletes an item' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
