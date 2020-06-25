require 'rails_helper'

RSpec.describe GroupMessageCommentPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let!(:group_message) { create(:group_message, group: group, owner: user) }
  let(:group_message_comment) { create(:group_message_comment, message: group_message) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, [group_message, group_message_comment]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'update?' do
        context 'when user is the record author' do
          before do
            create(:group_message_comment, author_id: user.id, message: group_message)
          end
          it 'returns true' do
            expect(subject.update?).to eq true
          end
        end

        context 'when manage_all is true' do
          before { user.policy_group.update manage_all: true }
            it 'returns true for #update?' do
              expect(subject.update?).to eq true
            end
        end

        context 'when manage_posts is true' do
          before { user.policy_group.update manage_posts: true }
          it 'returns true for #update?' do
            expect(subject.update?).to eq true
          end
        end
      end

    end
  end
end
