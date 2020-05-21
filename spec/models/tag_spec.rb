require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'when validating' do
    let(:tag) { build_stubbed(:tag) }

    it { expect(tag).to belong_to(:resource) }

    it { expect(tag).to validate_presence_of(:name) }
  end
end
