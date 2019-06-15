require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'when validating' do
    let(:budget) { build(:budget) }
    let(:approved_budget) { build :approved_budget }

    it { expect(budget).to belong_to(:group) }
    it { expect(budget).to belong_to(:approver).class_name('User').with_foreign_key('approver_id') }
    it { expect(budget).to belong_to(:requester).class_name('User').with_foreign_key('requester_id') }
    it { expect(budget).to have_many(:checklists) }
    it { expect(budget).to have_many(:budget_items) }

    it { expect(budget).to accept_nested_attributes_for(:budget_items).allow_destroy(true) }
  end

  describe 'amounts' do
    let!(:budget) { create :approved_budget }
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
        let!(:budget) { create :budget }

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
      allow(budget).to receive(:send_approval_notification)
      allow(budget).to receive(:send_denial_notification)
    end

    context 'on budget creation' do
      context 'when is_approved is true' do
        it 'sends email request' do
          budget.is_approved = true
          budget.save
          expect(budget).to have_received(:send_approval_notification)
        end
      end

      context 'is_approved is false' do
        it 'does not send email request' do
          budget.is_approved = false
          budget.save
          expect(budget).to have_received(:send_denial_notification)
        end
      end
    end

    context 'on budget update' do
      it 'does not send email request' do
        budget.save
        expect(budget).to have_received(:send_approval_request)
      end
    end
  end

  describe 'self.' do
    describe 'pre_approved_events' do
      let(:group) { create :group }
      let!(:budget) { create :budget, group: group }
      let!(:approved_budget) { create :approved_budget, group: group }

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
      let!(:group) { create(:group) }
      let!(:related_budgets) { create_list(:budget, 3, group: group, is_approved: true) }
      let!(:approved_budget) { create :approved_budget, group: group }

      subject { described_class }

      it 'expect 12 budget_items' do
        expect(subject.pre_approved_events(group).count).to eq 12
      end

      it 'select_items contain Leftover item' do
        select_items = subject.pre_approved_events_for_select(group)
        expect(select_items).to include [group.title_with_leftover_amount, -1]
      end
    end
  end

  describe 'status_title' do
    let(:budget) { build_stubbed(:budget) }

    it 'returns Pending' do
      expect(budget.status_title).to eq('Pending')
    end

    it 'returns Approved' do
      budget.is_approved = true
      expect(budget.status_title).to eq('Approved')
    end

    it 'returns Declined' do
      budget.is_approved = false
      expect(budget.status_title).to eq('Declined')
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      budget = create(:budget)
      budget.group.annual_budget = 10000
      checklist = create(:checklist, budget: budget)
      budget_item = create(:budget_item, budget: budget)

      budget.destroy

      expect { Budget.find(budget.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Checklist.find(checklist.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { BudgetItem.find(budget_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
