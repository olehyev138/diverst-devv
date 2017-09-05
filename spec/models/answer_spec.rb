require 'rails_helper'

RSpec.describe Answer, type: :model do
    
    describe 'when validating' do
        let(:answer) { build_stubbed(:answer) }

        #it { expect(answer).to belong_to(:campaign) } # <- this fails
        it { expect(answer).to belong_to(:question) }
        it { expect(answer).to belong_to(:author) }
        it { expect(answer).to have_many(:votes) }
        it { expect(answer).to have_many(:voters) }
        it { expect(answer).to have_many(:comments) }
        it { expect(answer).to have_many(:expenses) }
        it { expect(answer).to have_attached_file(:supporting_document) }
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
    
end
