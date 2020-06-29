require 'rails_helper'

RSpec.describe CsvFile, type: :model do
  let(:csv_file) { build_stubbed(:csv_file) }

  describe 'test associations and validations' do
    it { expect(csv_file).to belong_to(:user) }
    it { expect(csv_file).to belong_to(:group) }

    # ActiveStorage
    it { expect(csv_file).to have_attached_file(:import_file) }
    it { expect(csv_file).to have_attached_file(:download_file) }
    # it { expect(csv_file).to validate_attachment_presence(:download_file) }
    # it { expect(csv_file).to validate_attachment_content_type(:download_file, ['text/csv']) }
  end

  describe 'active storage import file' do
    let(:csv_file) { create(:csv_file) }
    it { expect(csv_file).to validate_attachment_presence(:import_file) }
    it { expect(csv_file).to validate_attachment_content_type(:import_file, ['text/csv']) }
  end

  describe 'active storage download file' do
    let(:csv_file) { create(:csv_file_download, download_file_name: 'name') }
    it { expect(csv_file).to validate_attachment_presence(:download_file) }
    it { expect(csv_file).to validate_attachment_content_type(:download_file, ['text/csv']) }
  end

  describe 'test scopes' do
    context 'csv_file::approved' do
      let!(:download_files) { create(:csv_file, download_file_name: 'name') }

      it 'returns download files' do
        expect(CsvFile.download_files).to eq([download_files])
      end
    end
  end

  #  describe 'when validating' do
  #    let(:file) { build(:csv_file) }
  #
  #    it 'is valid' do
  #      expect(file).to be_valid
  #    end
  #  end
  #
  #  describe 'after creating' do
  #    context 'without group_id' do
  #      let(:file) { build(:csv_file) }
  #      before do
  #        allow(ImportCSVJob).to receive(:perform_later).and_return(true)
  #      end
  #      it 'calls ImportCSVJob' do
  #        file.save
  #        expect(ImportCSVJob).to have_received(:perform_later).with(file.id).once
  #      end
  #    end
  #
  #    context 'with group_id' do
  #      let(:group) { create(:group) }
  #      let(:file) { build(:csv_file, group_id: group.id) }
  #      before do
  #        allow(GroupMemberImportCSVJob).to receive(:perform_later).and_return(true)
  #      end
  #      it 'calls GroupMemberImportCSVJob' do
  #        file.save
  #        expect(GroupMemberImportCSVJob).to have_received(:perform_later).with(file.id).once
  #      end
  #    end
  #  end
end
