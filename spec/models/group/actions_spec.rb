require 'rails_helper'

RSpec.describe Group::Actions, type: :model do
  describe 'base_query' do
    it { expect(Group.base_query).to eq 'LOWER(groups.name) LIKE :search' }
  end

  describe 'valid_scopes' do
    it { expect(Group.valid_scopes.include?('all_children')).to eq true }
    it { expect(Group.valid_scopes.include?('all_parents')).to eq true }
    it { expect(Group.valid_scopes.include?('no_children')).to eq true }
    it { expect(Group.valid_scopes.include?('is_private')).to eq true }
  end

  describe 'base_preloads' do
    it { expect(Group.base_preloads.include?(:parent)).to eq true }
    it { expect(Group.base_preloads.include?(:children)).to eq true }
  end

  describe 'base_preloads_budget' do
    it { expect(Group.base_preloads_budget.include?(:annual_budgets)).to eq true }
  end

  describe 'base_preload_no_recursion' do
    it { expect(Group.base_preload_no_recursion.include?(:user_groups)).to eq true }
    it { expect(Group.base_preload_no_recursion.include?(:group_leaders)).to eq true }
    it { expect(Group.base_preload_no_recursion.include?(:children)).to eq true }
    it { expect(Group.base_preload_no_recursion.include?(:parent)).to eq true }
    it { expect(Group.base_preload_no_recursion.include?(:enterprise)).to eq true }
  end

  describe 'base_attributes_preloads' do
    it { expect(Group.base_attributes_preloads.include?(:news_feed)).to eq true }
    it { expect(Group.base_attributes_preloads.include?(:annual_budgets)).to eq true }
    it { expect(Group.base_attributes_preloads.include?(:logo_attachment)).to eq true }
    it { expect(Group.base_attributes_preloads.include?(:banner_attachment)).to eq true }
    it { expect(Group.base_attributes_preloads.include?({ enterprise: [:theme] })).to eq true }
  end

  describe 'update_child_categories' do
    let!(:parent_group) { create(:group) }
    let!(:sub_group1) { create(:group) }
    let!(:sub_group2) { create(:group) }
    let!(:group_category_type) { create(:group_category_type) }
    let!(:group_category) { create(:group_category, group_category_type_id: group_category_type.id) }

    it 'ID required' do
      expect { Group.update_child_categories(Request.create_request(create(:user)), {}) }.to raise_error(BadRequestException)
    end

    it 'update categories' do
      params = { id: parent_group.id,
                 name: parent_group.name,
                 group_category_type_id: group_category_type.id,
                 children: [{ id: sub_group1.id, group_category_id: group_category.id, group_category_type_id: group_category_type.id }],
                 group: { id: parent_group.id } }
      expect(Group.update_child_categories(Request.create_request(create(:user)), params)).to_not be nil
    end
  end
end
