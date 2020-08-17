require 'rails_helper'

model = 'InitiativeField'
RSpec.describe 'InitiativeFields', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    before do
      get "/api/v1/#{route}", headers: headers
    end

    it 'gets all items' do
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes', skip: 'no serializer' do
      expect(JSON.parse(response.body)['page']['items'].first).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:index).and_raise(BadRequestException)
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#show' do
    before do
      get "/api/v1/#{route}/#{item.id}", headers: headers
    end

    it 'gets an item' do
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes', skip: 'no serializer' do
      expect(JSON.parse(response.body)['initiative_field']).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    let(:new_item) { build(route.singularize.to_sym) }

    before do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item.attributes }, headers: headers
    end

    it 'creates an item' do
      expect(response).to have_http_status(201)
    end

    it 'contains expected attributes', skip: 'no serializer' do
      id = JSON.parse(response.body)['initiative_field']['id']
      expect(model.constantize.find(id).field_id).to eq new_item.field_id
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    let(:new_field) { create(:field) }
    let(:new_params) { { id: item.id, field_id: new_field.id } }

    before do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
    end

    it 'updates an item' do
      expect(response).to have_http_status(:ok)
    end

    it 'contains expected attributes' do
      expect(model.constantize.find(item.id).field_id).to eq new_params[:field_id]
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
    include_examples 'InvalidInputException when updating', model
  end

  describe '#destroy' do
    before do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
    end

    it 'deletes an item' do
      expect(response).to have_http_status(:no_content)
    end

    it 'returns nil' do
      record = model.constantize.find(item.id) rescue nil
      expect(record).to eq nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
