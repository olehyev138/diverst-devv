require 'rails_helper'

RSpec.describe HtmlSanitizingHelper do
  describe '#strip_tags' do
    it 'strips tags in found in string' do
      string = 'Strip <i>these</i> tags!'
      expect(strip_tags(string)).to eq 'Strip these tags!'
    end
  end
end
