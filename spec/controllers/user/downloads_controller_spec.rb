require 'rails_helper'

RSpec.describe User::DownloadsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:csv_file) { create(:csv_file, user: user, download_file: File.new("#{Rails.root}/spec/fixtures/files/sponsor_image.jpg")) }

  login_user_from_let

  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :index }

      it 'returns success' do
        expect(response).to be_success
      end
    end

    context 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#download' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :download, { download_id: csv_file.id } }

      it 'redirects successfully' do
        expect(response.status).to eq(302)
      end
    end

    context 'when user is not logged in' do
      before { get :download, { download_id: csv_file.id } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
