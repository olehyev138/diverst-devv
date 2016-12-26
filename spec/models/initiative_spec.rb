require 'rails_helper'

RSpec.describe Initiative, type: :model do
  describe 'factory' do
    let(:initiative) { FactoryGirl.build(:initiative) }

    it 'is valid' do
      expect(initiative).to be_valid
    end
  end

  describe 'budgeting' do
    let(:group) { FactoryGirl.create(:group) }

    context 'without funds' do
      let(:initiative) { FactoryGirl.build(:initiative, owner_group: group, estimated_funding: 0) }

      it 'is valid without budget' do
        expect(initiative).to be_valid
      end
    end

    context 'with funds' do
      let(:initiative) { FactoryGirl.build(:initiative, estimated_funding: 100) }

      context 'without budget' do
        it 'is not valid' do
          expect(initiative).to_not be_valid
        end
      end

      context 'with incorrect budget' do
        let(:new_budget) { FactoryGirl.create(:budget) }

        before { initiative.budget = new_budget }

        it 'is not valid' do
          expect(initiative).to_not be_valid
        end
      end

      context 'with correct budget item' do
        let!(:initiative) { FactoryGirl.build(:initiative, :with_budget_item) }

        context 'with not enough budget money' do
          before { initiative.estimated_funding = initiative.budget_item.available_amount + 100 }

          it 'shows error' do
            expect(initiative).to_not be_valid
          end
        end

        context 'with enough budget money' do
          let!(:estimated_funding) { initiative.estimated_funding }
          let!(:available_amount) { initiative.budget_item.available_amount }

          before { initiative.save; initiative.reload }

          it 'saves initiative with correct funding' do
            expect(initiative).to_not be_new_record

            expect(initiative.estimated_funding).to eq estimated_funding
          end

          it 'substracts estimated funding from budget item' do
            leftover = available_amount - estimated_funding
            expect(initiative.budget_item.available_amount).to eq leftover
          end

          it 'marks budget item as done'
        end
      end
    end
  end
end
