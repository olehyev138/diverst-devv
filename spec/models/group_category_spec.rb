require 'rails_helper'

RSpec.describe GroupCategory, type: :model do
  let(:group_category) { build_stubbed(:group_category) }

  it { expect(group_category).to validate_presence_of(:name) }
  it { expect(group_category).to belong_to(:group_category_type) }
  it { expect(group_category).to belong_to(:enterprise) }
  it { expect(group_category).to have_many(:groups) }

  it { expect(group_category).to validate_presence_of(:name) }

  describe '#to_s' do
    let(:group_category) { build(:group_category, name: 'red') }

    it 'returns name of group category' do
      expect(group_category.to_s).to eq('red')
    end

    it 'allow string interpolation' do
      expect("#{group_category}").to eq('red')
    end
  end

  describe 'total_groups' do
    let!(:groups) { create_list(:group, 3) }
    let!(:group_category) { create(:group_category) }
    it 'returns total groups' do
      Group.update_all(group_category_id: group_category.id)
      expect(group_category.total_groups).to eq 3
    end
  end
end
