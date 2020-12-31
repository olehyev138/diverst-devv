require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'when validating' do
    let(:budget) { build(:budget) }
    let(:approved) { build :approved_budget }

    it { expect(budget).to have_one(:group) }
    it { expect(budget).to belong_to(:annual_budget) }
    it { expect(budget).to belong_to(:approver).class_name('User').with_foreign_key('approver_id') }
    it { expect(budget).to belong_to(:requester).class_name('User').with_foreign_key('requester_id') }
    it { expect(budget).to have_many(:checklists).dependent(:destroy) }
    it { expect(budget).to have_many(:budget_items).dependent(:destroy) }

    it { expect(budget).to accept_nested_attributes_for(:budget_items).allow_destroy(true) }

    it { expect(budget).to validate_length_of(:decline_reason).is_at_most(191) }
    it { expect(budget).to validate_length_of(:comments).is_at_most(65535) }
    it { expect(budget).to validate_length_of(:description).is_at_most(65535) }
  end

  describe 'test scopes' do
    context 'budget::approved' do
      let!(:approved_budget) { create(:budget, is_approved: true) }

      it 'returns budget approved' do
        expect(Budget.approved).to eq([approved_budget])
      end
    end

    context 'budget::not_approved' do
      let!(:not_approved_budget) { create(:budget, is_approved: false) }

      it 'returns budget not approved' do
        expect(Budget.not_approved).to eq([not_approved_budget])
      end
    end

    context 'budget::pending' do
      let!(:budgets) { create_list(:budget, 3) }

      it 'returns pending budget' do
        expect(Budget.pending.ids.sort).to eq(budgets.pluck(:id).sort)
      end
    end
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
      let!(:approved) { create :approved_budget, group: group }

      subject { described_class.pre_approved_events(group) }

      it 'contain items only from approved budgets' do
        expect(subject).to include approved.budget_items.first
        expect(subject).to_not include budget.budget_items.first
      end

      it 'contain only items that are not done yet' do
        approved.budget_items.first.update(is_done: true)

        expect(subject).to_not include approved.budget_items.first
      end

      it 'contain Leftover item'
    end
  end

  describe 'status_title' do
    let(:budget) { build(:budget) }

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
    let!(:group) { create(:group) }
    let!(:annual_budget) { create(:annual_budget, group: group, amount: 10000) }
    let!(:budget) { create(:budget, annual_budget: annual_budget, budget_items: build_list(:budget_item, 1)) }
    let!(:checklist) { create(:checklist, budget: budget) }
    let!(:budget_item) { budget.budget_items.first }

    it 'removes the child objects' do
      budget.destroy

      expect { Budget.find(budget.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Checklist.find(checklist.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { BudgetItem.find(budget_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'deducts approved budget from annual budget when budget is destroyed' do
      budget.update(is_approved: true, annual_budget: annual_budget)

      expect(annual_budget.approved).to eq group.annual_budget_approved

      budget.destroy
      group.reload
      annual_budget.reload

      expect(group.annual_budget_approved).to eq 0
      expect(annual_budget.approved).to eq 0
    end
  end
end
