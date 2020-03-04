require 'rails_helper'

RSpec.describe GroupCategoryType, type: :model do
  let(:group_category_type) { build_stubbed(:group_category_type) }

  it { expect(group_category_type).to validate_presence_of(:name) }
  it { expect(group_category_type).to have_many(:group_categories) }
  it { expect(group_category_type).to have_many(:groups) }


  context '#category_names=(names)' do
    let!(:group_category_type) { create(:group_category_type) }

    it 'produces 4 group categories', skip: 'in middle of refactor' do
      group_category_type.category_names = 'red, blue, green, yellow'
      group_category_type.reload
      expect(group_category_type.group_categories.count).to eq 4
    end

    it 'produces no group categories', skip: 'in middle of refactor' do
      group_category_type.category_names = ''
      group_category_type.reload
      expect(group_category_type.group_categories.count).to eq 0
    end
  end

  context 'test after_save callback' do
    let!(:group_category_type) { build(:group_category_type) }

    it 'run #create_association_with_enterprise callback' do
      expect(group_category_type).to receive(:create_association_with_enterprise)
      group_category_type.save
    end
  end
end
