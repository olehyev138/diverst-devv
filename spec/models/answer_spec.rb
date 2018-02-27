require 'rails_helper'

RSpec.describe Answer, type: :model do

    describe 'when validating' do
        let(:answer) { build_stubbed(:answer) }

        describe 'test associations and validations' do
            it { expect(answer).to belong_to(:question).inverse_of(:answers) }
            it { expect(answer).to belong_to(:author).class_name('User').inverse_of(:answers) }
            it { expect(answer).to have_many(:votes).class_name('AnswerUpvote') }
            it { expect(answer).to have_many(:voters).through(:votes).class_name('User').source(:user) }
            it { expect(answer).to have_many(:comments).class_name('AnswerComment') }
            it { expect(answer).to have_many(:expenses).class_name('AnswerExpense') }
            it { expect(answer).to accept_nested_attributes_for(:expenses).allow_destroy(true) }

            it { expect(answer).to have_attached_file(:supporting_document) }
            it { expect(answer).to validate_presence_of(:question) }
            it { expect(answer).to validate_presence_of(:author) }
            it { expect(answer).to validate_presence_of(:content)}
        end
    end

    describe '#total_value' do
        it "returns 0" do
            answer = create :answer
            expect(answer.total_value).to eq(0)
        end

        it "returns 100" do
            answer = create :answer
            answer.value = 100
            expect(answer.total_value).to eq(100)
        end

        it "returns 500" do
            answer = create :answer, value: 100
            expense = create :expense, income: true, price: 10
            create_list :answer_expense, 4, answer: answer, expense: expense, quantity: 10
            expect(answer.total_value).to eq(500)
        end
    end

    describe '#supporting_document_extension' do
        it "returns '' " do
            answer = create :answer
            expect(answer.supporting_document_extension).to eq("")
        end
    end

end
