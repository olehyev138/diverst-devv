require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    let(:question) { build_stubbed(:question) }

    it { expect(question).to belong_to(:campaign).counter_cache(true) }
    it { expect(question).to have_many(:answer_comments).through(:answers).source(:comments) }
    it { expect(question).to have_many(:answers).inverse_of(:question).dependent(:destroy) }

    it { expect(question).to accept_nested_attributes_for(:answers).allow_destroy(true) }

    it { expect(question).to validate_presence_of(:title) }
    it { expect(question).to validate_presence_of(:description) }
    it { expect(question).to validate_presence_of(:campaign) }

    it { expect(question).to validate_length_of(:conclusion).is_at_most(65535) }
    it { expect(question).to validate_length_of(:description).is_at_most(65535) }
    it { expect(question).to validate_length_of(:title).is_at_most(191) }

    describe '.solved' do
      let!(:question) { create(:question, solved_at: DateTime.now) }

      it { expect(described_class.solved).to eq([question]) }
    end
  end
end
