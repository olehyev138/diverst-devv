require 'rails_helper'

model = 'GroupMessageComment'
RSpec.describe 'GroupMessageComments', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:group_message) { create(:group_message, group: group) }
  let!(:item) { create(:group_message_comment, message: group_message) }
  let(:route) { 'group_message_comments' }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['page']['items'].first).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:index).and_raise(BadRequestException)
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#show' do
    it 'gets an item' do
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['group_message_comment']).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    it 'creates an item' do
      new_item = build(route.singularize.to_sym, content: 'test')
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item.attributes }, headers: headers
      expect(response).to have_http_status(201)
      id = JSON.parse(response.body)['group_message_comment']['id']
      expect(model.constantize.find(id).content).to eq new_item.content
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
      new_params = { id: item.id, content: 'test content' }
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(model.constantize.find(item.id).content).to eq new_params[:content]
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#destroy' do
    it 'deletes an item' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
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
