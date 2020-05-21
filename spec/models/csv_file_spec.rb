require 'rails_helper'

RSpec.describe CsvFile, type: :model do
  let(:file) { build(:csv_file) }

  describe 'associations' do
    it { expect(file).to belong_to(:user) }
    it { expect(file).to belong_to(:group) }
  end

  describe 'when validating' do
    before { file.save }

    it { expect(file).to have_attached_file(:import_file) }
    it { expect(file).to have_attached_file(:download_file) }

    it 'is valid' do
      expect(file).to be_valid
    end
  end

  describe 'after creating' do
    context 'without group_id' do
      before do
        allow(ImportCSVJob).to receive(:perform_later).and_return(true)
      end
      it 'calls ImportCSVJob' do
        file.save
        expect(ImportCSVJob).to have_received(:perform_later).with(file.id).once
      end
    end

    context 'with group_id' do
      let(:group) { create(:group) }
      let(:file) { build(:csv_file, group_id: group.id) }
      before do
        allow(GroupMemberImportCSVJob).to receive(:perform_later).and_return(true)
      end
      it 'calls GroupMemberImportCSVJob' do
        file.save
        expect(GroupMemberImportCSVJob).to have_received(:perform_later).with(file.id).once
      end
    end
  end
end
