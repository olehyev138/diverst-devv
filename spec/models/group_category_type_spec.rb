require 'rails_helper'

RSpec.describe GroupCategoryType, type: :model do
  
  let(:group_category_type) { build(:group_category_type) }

  it{expect(group_category_type).to validate_presence_of(:name)}
  it{expect(group_category_type).to have_many(:group_categories)}
  it{expect(group_category_type).to have_many(:groups)}
end
