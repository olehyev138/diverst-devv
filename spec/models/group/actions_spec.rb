require 'rails_helper'

RSpec.describe Group::Actions, type: :model do
  describe 'base_query' do
    it { expect(Group.base_query).to eq 'LOWER(groups.name) LIKE :search OR LOWER(children_groups.name) LIKE :search' }
  end

  describe 'valid_scopes' do
    let!(:valid_scopes) { %w(all_children all_parents no_children is_private joined_groups) }
    it { expect(Group.valid_scopes).to eq valid_scopes }
  end

  describe 'base_preloads' do
    let!(:base_preloads) { [:news_feed, :annual_budgets, :logo_attachment, :banner_attachment, { enterprise: [ :theme ] }, :user_groups, :group_leaders, :children, :parent, :enterprise,
                            { children: [:news_feed,
                                         :annual_budgets,
                                         :logo_attachment,
                                         :banner_attachment,
                                         { enterprise: [:theme] },
                                         :user_groups,
                                         :group_leaders,
                                         :children,
                                         :parent,
                                         :enterprise],
                              parent: [:news_feed,
                                       :annual_budgets,
                                       :logo_attachment,
                                       :banner_attachment,
                                       { enterprise: [:theme] },
                                       :user_groups,
                                       :group_leaders,
                                       :children,
                                       :parent,
                                       :enterprise] }]
    }
    it { expect(Group.base_preloads).to eq base_preloads }
  end

  describe 'base_preloads_budget' do
    let!(:base_preloads_budget) { [:annual_budgets] }
    it { expect(Group.base_preloads_budget).to eq base_preloads_budget }
  end

  describe 'base_preload_no_recursion' do
    let!(:base_preload_no_recursion) { [:news_feed, :annual_budgets, :logo_attachment, :banner_attachment, { enterprise: [ :theme ] }, :user_groups, :group_leaders, :children, :parent, :enterprise] }
    it { expect(Group.base_preload_no_recursion).to eq base_preload_no_recursion }
  end

  describe 'base_attributes_preloads' do
    let!(:base_attributes_preloads) { [:news_feed, :annual_budgets, :logo_attachment, :banner_attachment, { enterprise: [ :theme ] }] }
    it { expect(Group.base_attributes_preloads).to eq base_attributes_preloads }
  end

  describe 'update_child_categories' do
    let!(:parent_group) { create(:group) }
    let!(:sub_group1) { create(:group) }
    let!(:sub_group2) { create(:group) }
    let!(:group_category_type) { create(:group_category_type) }
    let!(:group_category) { create(:group_category, group_category_type_id: group_category_type.id) }

    it 'raises an exception if ID is missing' do
      expect { Group.update_child_categories(Request.create_request(create(:user)), {}) }.to raise_error(BadRequestException)
    end
    it 'raises an exception if symbol is missing' do
      expect { Group.update_child_categories(Request.create_request(create(:user)), { id: parent_group.id }) }.to raise_error(BadRequestException)
    end

    it 'updates categories' do
      params = { id: parent_group.id,
                 name: parent_group.name,
                 group_category_type_id: group_category_type.id,
                 children: [{ id: sub_group1.id, group_category_id: group_category.id, group_category_type_id: group_category_type.id }],
                 group: { id: parent_group.id } }
      expect(Group.update_child_categories(Request.create_request(create(:user)), params)).to_not be nil
    end
  end

  describe 'carryover_annual_budget' do
    it 'raises an exception if id is missing ' do
      group_without_id = build(:group, id: nil)
      expect { group_without_id.carryover_annual_budget(Request.create_request(create(:user))) }.to raise_error(BadRequestException)
    end

    it 'raises an exception if annual budget is missing' do
      group_without_budget = build(:group)
      expect { group_without_budget.carryover_annual_budget(Request.create_request(create(:user))) }.to raise_error(BadRequestException)
    end

    let!(:annual_budget) { create(:annual_budget, amount: 100) }

    it 'raises an exception if budget can not be reset' do
      group = annual_budget.group
      create(:budget, annual_budget_id: annual_budget.id, is_approved: true)
      expect { group.carryover_annual_budget(Request.create_request(create(:user))) }.to raise_error(InvalidInputException)
    end

    it 'carries over successfully' do
      group = annual_budget.group
      expect(group.carryover_annual_budget(Request.create_request(create(:user))).annual_budget).to eq 100
    end
  end

  describe 'reset_annual_budget' do
    it 'raises an exception if id is missing' do
      group_without_id = build(:group, id: nil)
      expect { group_without_id.reset_annual_budget(Request.create_request(create(:user))) }.to raise_error(BadRequestException)
    end

    it 'raises an exception if annual budget is missing' do
      group_without_budget = build(:group)
      expect { group_without_budget.reset_annual_budget(Request.create_request(create(:user))) }.to raise_error(BadRequestException)
    end

    let!(:annual_budget) { create(:annual_budget, amount: 100) }

    it 'raises an exception if budgetcan not be reset' do
      group = annual_budget.group
      create(:budget, annual_budget_id: annual_budget.id, is_approved: true)
      expect { group.reset_annual_budget(Request.create_request(create(:user))) }.to raise_error(InvalidInputException)
    end

    it 'resets successfully' do
      group = annual_budget.group
      expect(group.reset_annual_budget(Request.create_request(create(:user))).annual_budget).to eq 100
    end
  end
end
