require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'when validating' do
    let(:tag) { FactoryGirl.build_stubbed(:tag) }

    it { expect(tag).to belong_to(:taggable) }

    it { expect(tag).to validate_presence_of(:taggable).on(:update) }
    it { expect(tag).to validate_presence_of(:name)}
  end
end
