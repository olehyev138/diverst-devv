require 'rails_helper'

RSpec.describe CsvFile, type: :model do
  describe 'when validating' do
    let(:file) { build(:csv_file)}

    it 'is valid' do
      expect(file).to be_valid
    end
  end

  describe 'after creating' do
    let(:file) { build(:csv_file)}
    before do
      allow(ImportCSVJob).to receive(:perform_later).and_return(true)
    end
    it 'calls ImportCSVJob' do
      file.save
      expect(ImportCSVJob).to have_received(:perform_later).with(file.id).once
    end
  end
end
