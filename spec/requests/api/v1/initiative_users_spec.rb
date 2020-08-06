require 'rails_helper'

model = 'InitiativeUser'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:initiative) { create(:initiative, owner_group: group) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, initiative: initiative) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    before do
      get "/api/v1/#{route}?initiative_id=#{initiative.id}", headers: headers
    end

    it 'gets all items' do
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes' do
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

    it 'gets a item' do
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes' do
      expect(JSON.parse(response.body)['initiative_user']).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    let!(:new_item) { build(route.singularize.to_sym) }
    before do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item.attributes }, headers: headers
    end

    it 'creates an item' do
      expect(response).to have_http_status(201)
    end

    it 'contains expected attributes' do
      id = JSON.parse(response.body)['initiative_user']['id']
      expect(model.constantize.find(id).user_id).to eq new_item.user_id
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}": build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    let!(:new_params) { { id: item.id, attended: true, check_in_time: Time.now } }
    before do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
    end

    it 'updates an item' do
      expect(response).to have_http_status(:ok)
    end

    it 'contains expected attributes' do
      expect(model.constantize.find(item.id).attended).to eq new_params[:attended]
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}": item.attributes }, headers: headers
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

  describe '#join' do
    let!(:event) { create(:initiative) }
    let!(:new_params) { { initiative_id: event.id } }

    it 'join an event' do
      post "/api/v1/#{route}/join", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(response).to have_http_status(:created)
      id = JSON.parse(response.body)['initiative_user']['id']
      expect(model.constantize.find(id).initiative_id).to eq new_params[:initiative_id]
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/join", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the InvalidInputException' do
      allow(model.constantize).to receive(:find).and_raise(InvalidInputException)
      post "/api/v1/#{route}/join", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#leave' do
    let!(:current_user) { create(:user, password: 'password', enterprise: enterprise) }
    let!(:initiative_user) { create(model.constantize.table_name.singularize.to_sym, user: current_user) }
    let!(:new_headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => UserTokenService.create_jwt(current_user) } }

    let!(:new_params) { { initiative_id: initiative_user.initiative_id } }

    it 'leave an event' do
      post "/api/v1/#{route}/leave", params: { "#{route.singularize}" => new_params }, headers: new_headers
      expect(response).to have_http_status(:no_content)
      record = model.constantize.find_by(initiative_id: initiative_user.initiative_id, current_user: item.user_id) rescue nil
      expect(record).to eq nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/leave", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the InvalidInputException' do
      allow(model.constantize).to receive(:find).and_raise(InvalidInputException)
      post "/api/v1/#{route}/leave", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
