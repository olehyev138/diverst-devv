require 'rails_helper'

model = 'Initiative'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, owner_group: group) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes' do
      get "/api/v1/#{route}", headers: headers
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
    end

    it 'JSON body response contains expected attributes' do
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(JSON.parse(response.body)['initiative']).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    let(:new_item) { build(route.singularize.to_sym) }

    it 'creates an item' do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item.attributes }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'contains expected attributes' do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item.attributes }, headers: headers
      id = JSON.parse(response.body)['initiative']['id']
      expect(model.constantize.find(id).name).to eq new_item.name
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    let(:new_params) { { id: item.id, name: 'test' } }

    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'contains expected attributes' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(model.constantize.find(item.id).name).to eq new_params[:name]
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

    it 'destroys item in the database' do
      expect { delete "/api/v1/#{route}/#{item.id}", headers: headers }.to change(model.constantize, :count).by(-1)
    end

    it 'returns nil' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      record = model.constantize.find(item.id) rescue nil
      expect(record).to eq nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#generate_qr_code' do
    it 'creates a QR code for the initiative' do
      post "/api/v1/#{route}/#{item.id}/qrcode", headers: headers
      expect(response).to have_http_status(:ok)
      expect(model.constantize.find(item.id).qr_code).to_not be nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:generate_qr_code).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/qrcode", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#fields' do
    let!(:field) { create(:field_defined_by_initiative, field_definer: item) }

    it 'gets fields' do
      get "/api/v1/#{route}/#{item.id}/fields", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes' do
      get "/api/v1/#{route}/#{item.id}/fields", params: {}, headers: headers
      expect(JSON.parse(response.body)['page']['items'].first).to include('id' => field.id)
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/fields", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create field' do
    let!(:new_item) { build(:field) }

    it 'creates a field' do
      post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field' => new_item.attributes }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'contains expected attributes' do
      post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field' => new_item.attributes }, headers: headers
      id = JSON.parse(response.body)['text_field']['id']
      expect(Field.find(id).title).to eq new_item.title
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_field", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#updates' do
    let!(:update) { create(:initiative_update2, initiative: item) }

    it 'gets updates' do
      get "/api/v1/#{route}/#{item.id}/updates", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'JSON body response contains expected attributes' do
      get "/api/v1/#{route}/#{item.id}/updates", params: {}, headers: headers
      expect(JSON.parse(response.body)['page']['items'].first).to include('id' => update.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/updates", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update_prototype' do
    let!(:update) { create(:initiative_update2, initiative: item) }

    it 'updates prototype' do
      get "/api/v1/#{route}/#{item.id}/update_prototype", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns prototype' do
      get "/api/v1/#{route}/#{item.id}/update_prototype", params: {}, headers: headers
      expect(JSON.parse(response.body)['update']).to_not be nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/update_prototype", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create_update' do
    let!(:new_item) { build(:initiative_update2) }

    it 'creates an update' do
      post "/api/v1/#{route}/#{item.id}/create_update", params: { 'update' => new_item.attributes }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'contains expected attributes' do
      post "/api/v1/#{route}/#{item.id}/create_update", params: { 'update' => new_item.attributes }, headers: headers
      id = JSON.parse(response.body)['update']['id']
      expect(Update.find(id).updatable_type).to eq new_item.updatable_type
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_update", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#archive' do
    it 'archives an item' do
      post "/api/v1/#{route}/#{item.id}/archive", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(Initiative.find(item.id).archived_at).to_not be nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/archive", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the InvalidInputException' do
      allow(model.constantize).to receive(:find).and_raise(InvalidInputException)
      post "/api/v1/#{route}/#{item.id}/archive", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#un_archive' do
    it 'unarchives an item' do
      put "/api/v1/#{route}/#{item.id}/un_archive", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(Initiative.find(item.id).archived_at).to be nil
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      put "/api/v1/#{route}/#{item.id}/un_archive", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    it 'captures the InvalidInputException' do
      allow(model.constantize).to receive(:find).and_raise(InvalidInputException)
      put "/api/v1/#{route}/#{item.id}/un_archive", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
