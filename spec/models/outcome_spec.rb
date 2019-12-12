require 'rails_helper'

RSpec.describe Outcome, type: :model do
  describe 'when validating' do
    let(:outcome) { build_stubbed(:outcome) }

    it { expect(outcome).to belong_to(:group) }

    it { expect(outcome).to have_many(:pillars).dependent(:destroy) }

    it { expect(outcome).to accept_nested_attributes_for(:pillars).allow_destroy(true) }
    it { expect(outcome).to validate_presence_of(:name) }
  end

  describe 'default_scope' do
    let!(:outcome) { create(:outcome) }

    it 'gets the outcome' do
      expect(Outcome.all).to eq [outcome]
    end
  end
end
