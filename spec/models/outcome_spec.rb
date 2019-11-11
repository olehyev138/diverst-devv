require 'rails_helper'

RSpec.describe Outcome, type: :model do
  describe 'when validating' do
    let(:outcome) { build_stubbed(:outcome) }

    it { expect(outcome).to belong_to(:group) }

    it { expect(outcome).to have_many(:pillars).dependent(:destroy) }

    it { expect(outcome).to accept_nested_attributes_for(:pillars).allow_destroy(true) }
    it { expect(outcome).to validate_presence_of(:name) }
    it { expect(outcome).to validate_length_of(:name).is_at_most(191) }
  end

  describe 'default_scope' do
    let(:outcome) { create(:outcome) }

    it 'gets the outcome' do
      expect(Outcome.all).to eq [outcome]
    end
  end

  describe 'test methods' do
    let!(:outcome) { create(:outcome) }
    let!(:pillars) { create_list(:pillar, 2, outcome: outcome) }
    let!(:initiative1) { create(:initiative, pillar_id: pillars.first.id) }
    let!(:initiative2) { create(:initiative, pillar_id: pillars.last.id) }

    describe '#get_initiatives' do
      it 'returns a flattened array of initiatives' do
        expect(outcome.get_initiatives).to eq [initiative1, initiative2]
      end
    end

    describe '.get_initiatives' do
      let!(:outcome1) { create(:outcome) }

      it 'returns all initiatives for a collection of outcomes' do
        pillar = create(:pillar, outcome: outcome)
        initiative3 = create(:initiative, pillar_id: pillar.id)

        expect(described_class.get_initiatives(Outcome.all)).to eq [initiative1, initiative2, initiative3]
      end
    end
  end
end
