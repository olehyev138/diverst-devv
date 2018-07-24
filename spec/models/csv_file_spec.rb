require 'rails_helper'

RSpec.describe CsvFile, type: :model do
  describe 'when validating' do
    let(:file) { build(:csv_file)}

    it 'is valid' do
      expect(file).to be_valid
    end
  end
end
