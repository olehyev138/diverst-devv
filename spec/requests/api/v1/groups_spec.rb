require 'rails_helper'

model = 'Group'
controller = Api::V1::GroupsController
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:field) { create(:field, type: 'NumericField') }
  let(:update) { create(:update) }
  let(:group_leader) { create(:group_leader) }
  let(:group) { create(:group, :with_annual_budget ) }

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
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:created)
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

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#fields' do
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

  describe '#create field' do
    it 'creates fields' do
      post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field': field.attributes }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_field", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#updates' do
    it 'gets updates' do
      get "/api/v1/#{route}/#{item.id}/updates", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/updates", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update_prototype' do
    it 'gets prototype update' do
      get "/api/v1/#{route}/#{item.id}/update_prototype", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/update_prototype", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create_update' do
    it 'create update' do
      post "/api/v1/#{route}/#{item.id}/create_update", params: { 'update': update.attributes }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_update",params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#assign_leaders' do
    it 'assigns a leader' do
      allow_any_instance_of(controller).to receive(:base_authorize).and_return(nil)
      put "/api/v1/#{route}/#{item.id}/assign_leaders", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      put "/api/v1/#{route}/#{item.id}/assign_leaders",params: { 'group_leader': group_leader.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#annual_budget' do
    it 'gets the annual budget' do
      allow_any_instance_of(controller).to receive(:base_authorize).and_return(nil)
      get "/api/v1/#{route}/#{item.id}/annual_budget", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow_any_instance_of(controller).to receive(:base_authorize).and_return(nil)
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/annual_budget", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  # TODO : wrong record bug
  describe '#carryover_annual_budget' do
    xit 'carryover the annual budget' do
      post "/api/v1/#{route}/#{item.id}/carryover_annual_budget", params: { 'group': group.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    xit 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/carryover_annual_budget", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  # TODO : wrong record bug
  describe '#reset_annual_budget' do
    xit 'reset the annual budget' do
      post "/api/v1/#{route}/#{item.id}/reset_annual_budget", params: { 'group': group.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    xit 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/reset_annual_budget", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  # TODO : wrong record bug
  describe '#update_categories' do
    xit 'update categories' do
      post "/api/v1/#{route}/#{item.id}/update_categories", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/update_categories", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
