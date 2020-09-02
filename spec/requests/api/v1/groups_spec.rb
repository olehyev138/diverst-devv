require 'rails_helper'

model = 'Group'
controller = Api::V1::GroupsController
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:subgroup) { create(:group) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, children: [subgroup]) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }
  !let(:field) { create(:field, type: 'NumericField') }
  let(:field2) { build_stubbed(:field) }
  let(:update) { create(:update) }
  let!(:group_leader) { create(:group_leader) }
  let!(:group) { create(:group, :with_annual_budget) }
  let!(:group_cateogry) { create(:group_category) }

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

    it 'inserts a group in the database' do
      expect { post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers }.to change(model.constantize, :count).by(1)
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

    it 'group has been updated' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => { 'id' => item.id, 'name' => 'Asian Blue Communitya' } }, headers: headers
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

    it 'destroys a group in the database' do
      expect { delete "/api/v1/#{route}/#{group.id}", headers: headers }.to change(model.constantize, :count).by(-1)
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

    # TODO : Fix bug, only one field should be inserted not 3
    xit 'inserts a fields in the database' do
      expect { post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field': field2.attributes }, headers: headers }.to change(Field, :count).by(1)
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

    # TODO : Fix bug, only one update should be inserted not 2
    xit 'inserts an update in the database' do
      expect { post "/api/v1/#{route}/#{item.id}/create_update", params: { 'update': update.attributes }, headers: headers }.to change(Update, :count).by(1)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_update", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#carryover_annual_budget' do
    it 'carryover the annual budget' do
      post "/api/v1/#{route}/#{group.id}/carryover_annual_budget", params: { 'group': group.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{group.id}/carryover_annual_budget", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#reset_annual_budget' do
    it 'reset the annual budget' do
      post "/api/v1/#{route}/#{group.id}/reset_annual_budget", params: { 'group': group.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{group.id}/reset_annual_budget", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update_categories' do
    it 'updates categories' do
      children = [{ 'id' => subgroup.id, 'name' => subgroup.name, 'group_category_id' => group_cateogry.id, 'group_category_type_id' => nil, 'category' => { 'value' => 1, 'label' => 'fdsd' } }]
      group = { 'id' => item.id, 'children' => children, 'group' => { 'id' => '14', 'name' => 'Asian Blue Communitya' } }
      post "/api/v1/#{route}/#{item.id}/update_categories", params: group, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'updates categories in the database' do
      children = [{ 'id' => subgroup.id, 'name' => subgroup.name, 'group_category_id' => group_cateogry.id, 'group_category_type_id' => nil, 'category' => { 'value' => 1, 'label' => 'fdsd' } }]
      group = { 'id' => item.id, 'children' => children, 'group' => { 'id' => '14', 'name' => 'Asian Blue Communitya' } }
      post "/api/v1/#{route}/#{item.id}/update_categories", params: group, headers: headers
      expect(item.children[0].group_category_id).to_not eq model.constantize.find(item.id).children[0].group_category_id
    end

    it 'captures the error when params are invalid, ie: no children' do
      post "/api/v1/#{route}/#{item.id}/update_categories", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/update_categories", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#calendar_colors' do
    xit 'captures the error' do
      allow_any_instance_of(controller).to receive(:base_authorize).and_return(nil)
      allow(model.constantize).to receive(:select).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/calendar_colors", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#calendar_colors' do
    xit 'captures the error' do
      allow_any_instance_of(controller).to receive(:base_authorize).and_return(nil)
      allow(model.constantize).to receive(:select).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/calendar_colors", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
