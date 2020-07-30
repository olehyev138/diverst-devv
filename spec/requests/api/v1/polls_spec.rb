require 'rails_helper'

model = 'Poll'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:field) { create(:field, type: 'NumericField') }

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
      attributes = build(route.singularize.to_sym).attributes
      attributes['fields_attributes'] = [{ type: 'SelectField', title: 'What is 1 + 1?', options_text: "1\r\n2\r\n3\r\n4\r\n5\r\n6\r\n7" }]
      post "/api/v1/#{route}", params: { "#{route.singularize}" => attributes }, headers: headers
      expect(response).to have_http_status(201)
      expect(Poll.last.status).to eq 'draft'
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#create and publish' do
    it 'creates an item' do
      attributes = build(route.singularize.to_sym).attributes
      attributes['fields_attributes'] = [{ type: 'SelectField', title: 'What is 1 + 1?', options_text: "1\r\n2\r\n3\r\n4\r\n5\r\n6\r\n7" }]
      post "/api/v1/#{route}/publish", params: { "#{route.singularize}" => attributes }, headers: headers
      expect(response).to have_http_status(201)
      expect(Poll.last.status).to eq 'published'
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}/publish", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update' do
    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when updating', model
  end

  describe '#update and publish' do
    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}/publish", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(item.reload.status).to eq 'published'
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}/publish", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#destroy' do
    it 'deletes an item' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  xdescribe '#fields' do
    it 'gets fields' do
      get "/api/v1/#{route}/#{item.id}/fields", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/fields", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  # TODO : Complete polls and capture error
  xdescribe '#create field' do
    it 'creates fields' do
      post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field': field.attributes }, headers: headers
      expect(response).to have_http_status(:created)
    end

    xit 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_field", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
