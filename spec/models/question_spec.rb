require 'rails_helper'

RSpec.describe Question, type: :model do

    describe 'validations' do
        let(:question) { build_stubbed(:question) }

        it{ expect(question).to validate_presence_of(:title) }
        it{ expect(question).to validate_presence_of(:description) }
        it{ expect(question).to validate_presence_of(:campaign) }

        it { expect(question).to belong_to(:campaign) }

        it{ expect(question).to have_many(:answer_comments).through(:answers).source(:comments) }

        it { expect(question).to have_many(:answers).inverse_of(:question).dependent(:destroy) }

        it { expect(question).to accept_nested_attributes_for(:answers).allow_destroy(true) }
    end
end
