require 'rails_helper'

RSpec.describe Folder::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(Folder.base_preloads.include?(:parent)).to eq true }
  end

  describe 'base_query' do
    it { expect(Folder.base_query).to eq 'LOWER(folders.name) LIKE :search' }
  end

  describe 'validate_password' do
    let!(:folder) { create(:folder, password_protected: true, password: 'testPassword') }

    it 'raises an exception if Folder ID and password are missing' do
      expect { Folder.validate_password(Request.create_request(create(:user)), {}) }.to raise_error(BadRequestException, 'Folder ID and password required')
    end

    it 'raises an exception if folder does not exist' do
      expect { Folder.validate_password(Request.create_request(create(:user)), { id: folder.id + 1, password: 'test' }) }.to raise_error(BadRequestException, 'Folder does not exist')
    end

    it 'raises an exception if password is incorrect' do
      expect { Folder.validate_password(Request.create_request(create(:user)), { id: folder.id, password: 'test' }) }.to raise_error(BadRequestException, 'Incorrect password')
    end

    it 'returns folder' do
      expect(Folder.validate_password(Request.create_request(create(:user)), { id: folder.id, password: 'testPassword' })).to eq folder
    end
  end
end
