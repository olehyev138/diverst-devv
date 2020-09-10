require 'rails_helper'

model = 'NewsLinkPhoto'
RSpec.describe "#{model.pluralize}", type: :request do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:news_link) { create(:news_link, author: user, group: group) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, news_link: news_link) }
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
      expect(JSON.parse(response.body)['news_link_photo']).to include('id' => item.id)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:show).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create' do
    let(:new_item) { build(route.singularize.to_sym).attributes }

    it 'creates an item' do
      new_item[:file] = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'contains file' do
      new_item[:file] = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')
      post "/api/v1/#{route}", params: { "#{route.singularize}" => new_item }, headers: headers
      id = JSON.parse(response.body)['news_link_photo']['id']
      expect(model.constantize.find(id).file.attached?).to be true
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    let(:new_params) { { id: item.id, file: nil } }
    let!(:old_file_location) { model.constantize.find(item.id).file_location }

    it 'updates an item' do
      new_params[:file] = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'contains expected attributes' do
      new_params[:file] = fixture_file_upload('spec/fixtures/files/verizon_logo.png', 'image/png')
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => new_params }, headers: headers
      expect(model.constantize.find(item.id).file_location).to_not eq old_file_location
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
end
