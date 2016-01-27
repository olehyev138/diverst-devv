require 'rails_helper'

RSpec.describe Resource do
  describe '#extension' do
    it "returns the file's extension in caps without the dot" do
      resource = build(:resource)
      expect(resource.file_extension).to eq 'PDF'
    end
  end
end
