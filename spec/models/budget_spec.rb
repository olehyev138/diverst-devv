require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'when validating' do
    let(:budget) { FactoryGirl.build_stubbed(:budget) }
    let(:approved_budget) { FactoryGirl.build :approved_budget }

    it { expect(budget).to validate_presence_of(:subject) }
    it { expect(budget).to belong_to(:subject) }
    it { expect(budget).to belong_to(:approver).class_name("User").with_foreign_key("approver_id") }
    it { expect(budget).to belong_to(:requester).class_name("User").with_foreign_key("requester_id") }
    it { expect(budget).to have_many(:checklists) }
    it { expect(budget).to have_many(:budget_items) }
  end

  describe 'amounts' do
    let!(:budget) { FactoryGirl.create :approved_budget }
    let(:requested_amount) { budget.budget_items.sum(:estimated_amount) }

    before { budget.budget_items.first.update(is_done: true) }

    describe '#requested_amount' do
      it 'sums all budget items' do
        expect(budget.requested_amount).to eq requested_amount
      end
    end

    describe '#available_amount' do
      context 'with approved budget' do
        before { budget.is_approved = true }

        it 'sums only active budget items' do
          active_available = requested_amount - budget.budget_items.first.estimated_amount

          expect(budget.available_amount).to eq active_available
        end
      end

      context 'with not approved budget' do
        let!(:budget) { FactoryGirl.create :budget }

        it 'always return 0' do
          expect(budget.available_amount).to eq 0
        end
      end
    end
  end

  describe 'approver notification on creation' do
    let(:user) { create :user }
    let(:budget) { build :budget }

    before do
      allow(budget).to receive(:send_approval_request)

      budget.save
    end

    context 'on budget creation' do
      context 'with approver_id' do
        let(:budget) { build :budget, approver_id: user.id }

        it 'sends email request' do
          expect(budget).to have_received(:send_approval_request)
        end
      end

      context 'without approver_id' do
        it 'does not send email request' do
          expect(budget).to_not have_received(:send_approval_request)
        end
      end
    end

    context 'on budget update' do
      it 'does not send email request' do
        expect(budget).to_not have_received(:send_approval_request)
      end
    end
  end

  describe 'self.' do
    describe 'pre_approved_events' do
      let(:group) { FactoryGirl.create :group }
      let!(:budget) { FactoryGirl.create :budget, subject: group }
      let!(:approved_budget) { FactoryGirl.create :approved_budget, subject: group }

      subject { described_class.pre_approved_events(group) }

      it 'contain items only from approved budgets' do
        expect(subject).to include approved_budget.budget_items.first
        expect(subject).to_not include budget.budget_items.first
      end

      it 'contain only items that are not done yet' do
        approved_budget.budget_items.first.update(is_done: true)

        expect(subject).to_not include approved_budget.budget_items.first
      end

      it 'contain Leftover item'
    end

    describe 'pre_approved_events_for_select' do
      xit 'implement me'
    end
  end
end
