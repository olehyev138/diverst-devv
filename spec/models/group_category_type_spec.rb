require 'rails_helper'

RSpec.describe GroupCategoryType, type: :model do
  let(:group_category_type) { build(:group_category_type) }

  it { expect(group_category_type).to have_many(:group_categories).dependent(:delete_all) }
  it { expect(group_category_type).to have_many(:groups).dependent(:nullify) }
  it { expect(group_category_type).to belong_to(:enterprise) }

  it { expect(group_category_type).to validate_length_of(:name).is_at_most(191) }
  it { expect(group_category_type).to validate_presence_of(:name) }
  it { expect(group_category_type).to validate_uniqueness_of(:name) }


  describe '#category_names=(names)' do
    let!(:group_category_type) { create(:group_category_type) }

    it 'produces 4 group categories' do
      group_category_type.category_names = 'red, blue, green, yellow'
      group_category_type.reload
      expect(group_category_type.group_categories.count).to eq 4
    end

    it 'produces no group categories' do
      group_category_type.category_names = ''
      group_category_type.reload
      expect(group_category_type.group_categories.count).to eq 0
    end
  end

  describe '#to_s' do
    let(:group_category_type) { build(:group_category_type, name: 'color') }

    it 'returns name of group category type' do
      expect(group_category_type.to_s).to eq('color')
    end

    it 'allow string interpolation' do
      expect("#{group_category_type}").to eq('color')
    end
  end

  describe 'test after_save callback' do
    let!(:group_category_type) { build(:group_category_type) }

    it 'run #create_association_with_enterprise callback' do
      expect(group_category_type).to receive(:create_association_with_enterprise)
      group_category_type.save
    end
  end
end
