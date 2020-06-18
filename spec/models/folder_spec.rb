require 'rails_helper'

RSpec.describe Folder, type: :model do
  let(:group) { create(:group) }
  let(:folder) { create(:folder, name: 'test', group: group) }

  describe 'test associations' do
    it { expect(folder).to have_many(:resources).dependent(:destroy) }
    it { expect(folder).to have_many(:folder_shares).dependent(:destroy) }
    it { expect(folder).to have_many(:groups).through(:folder_shares).source(:group) }
    it { expect(folder).to have_many(:views).dependent(:destroy) }
    it { expect(folder).to have_many(:children).class_name('Folder').with_foreign_key(:parent_id).dependent(:destroy) }

    it { expect(folder).to belong_to(:group) }
    it { expect(folder).to belong_to(:enterprise) }
    it { expect(folder).to belong_to(:parent).class_name('Folder').with_foreign_key(:parent_id) }
  end

  describe 'test validations' do
    it { expect(folder).to validate_length_of(:password_digest).is_at_most(191) }
    it { expect(folder).to validate_length_of(:name).is_at_most(191) }
    it { expect(folder).to validate_presence_of(:name) }

    before { folder.update(password_protected: true) }

    it { expect(folder).to validate_presence_of(:password) }
    it { expect(folder).to validate_length_of(:password).is_at_least(6) }

    it { expect(folder).to validate_uniqueness_of(:name).scoped_to(:group_id) }
    # Todo
    # describe 'test folder uniqueness enterprise' do
    #  let!(:enterprise) { create(:enterprise) }
    #  let!(:folder_enterprise) { create(:folder, enterprise: enterprise) }
    #  it { expect(folder_enterprise).to validate_uniqueness_of(:name).scoped_to(:enterprise_id) }
    # end
  end

  describe 'test that' do
    let!(:new_folder) { build(:folder) }

    it 'set_password callback runs before object is saved' do
      expect(new_folder).to receive(:set_password)
      new_folder.save
    end
  end

  describe '#password' do
    it 'doesnt create the password for the folder' do
      folder = build_stubbed(:folder)
      expect(folder.password_digest).to be(nil)
    end

    it 'doesnt save the password for the folder when password_protected is false' do
      folder = create(:folder, password: 'password', password_confirmation: 'password')
      expect(folder.password_digest).to be(nil)
    end

    it 'saves the password for the folder when password_protected is true' do
      folder = build_stubbed(:folder, password_protected: true, password: 'password', password_confirmation: 'password')
      expect(folder.password_digest).to_not be(nil)
    end

    it "saves the password for the folder when password_protected is true and doesn't validate the password" do
      folder = build_stubbed(:folder, password_protected: true, password: 'password', password_confirmation: 'password')
      expect(folder.valid_password?('faksakdas')).to_not be(true)
    end

    it 'saves the password for the folder when password_protected is true and validates the password' do
      folder = build_stubbed(:folder, password_protected: true, password: 'password', password_confirmation: 'password')
      expect(folder.valid_password?('password')).to be(folder)
    end
  end

  describe '#parent' do
    it 'returns nil' do
      folder = create(:folder)
      expect(folder.parent).to be(nil)
    end

    it 'returns parent' do
      folder_1 = create(:folder)
      folder_2 = create(:folder, parent: folder_1)

      expect(folder_2.parent).to_not be(nil)
      expect(folder_2.parent).to eq(folder_1)
    end
  end

  describe '#children' do
    it 'returns empty array' do
      folder = create(:folder)
      expect(folder.children.length).to eq(0)
    end

    it 'returns 1 child' do
      folder_1 = create(:folder)
      folder_2 = create(:folder, parent: folder_1)

      expect(folder_1.children).to include(folder_2)
    end
  end

  describe '#only_parents' do
    it 'returns empty array' do
      expect(Folder.only_parents.length).to eq(0)
    end

    it 'returns 1 parent' do
      folder_1 = create(:folder)
      folder_2 = create(:folder, parent: folder_1)

      expect(Folder.only_parents.length).to eq(1)
    end
  end

  describe '#total_views' do
    it 'returns 10' do
      folder = create(:folder)
      create_list(:view, 10, folder: folder)

      expect(folder.total_views).to eq(10)
    end
  end

  describe 'test callbacks' do
    context '#destroy_callbacks' do
      it 'removes the child objects' do
        folder = create(:folder)
        resource = create(:resource, folder: folder)
        folder_share = create(:folder_share, folder: folder)
        folder_child = create(:folder, parent: folder)

        folder.destroy!

        expect { Folder.find(folder.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Resource.find(resource.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { FolderShare.find(folder_share.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { Folder.find(folder_child.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#validate_password' do
    it 'returns the correct folder when id and password are present' do
      folder = create(:folder, password_protected: true, password: 'password')
      valid_folder = Folder.validate_password({}, { id: folder.id, password: 'password' })
      expect(valid_folder.id).to eq(folder.id)
    end

    it 'raises an error when password is invalid' do
      folder = create(:folder, password_protected: true, password: 'password')
      expect { Folder.validate_password({}, { id: folder.id, password: 'fake' }) }.to raise_error(BadRequestException, 'Incorrect password')
    end
  end
end
