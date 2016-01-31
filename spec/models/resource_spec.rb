require 'rails_helper'

RSpec.describe Resource do
  describe '#extension' do
    it "returns the file's lowercase extension without the dot" do
      resource = build(:resource)
      expect(resource.file_extension).to eq 'pdf'
    end
  end
end
