require 'rails_helper'

model = 'GroupLeader'
RSpec.describe 'RegionLeaders', type: :request do
  let(:remove_leader_of) {
    -> (attrs) {
      attrs['region_id'] = attrs['leader_of_id']
      attrs.delete('leader_of_id')
      attrs.delete('leader_of_type')
      attrs
    }
  }
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:region) { create(:region, parent: group) }
  let(:item) { create(:region_leader, leader_of: region) }
  let(:route) { 'region_leaders' }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:params) { { group_id: group.id } }
  let(:build_params) { remove_leader_of[build(:region_leader).attributes.dup] }
  let(:attr_params) { remove_leader_of[item.attributes.dup] }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}", headers: headers
      Clipboard.copy response.body
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
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build_params }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build_params }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => attr_params }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => attr_params }, headers: headers
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
end
