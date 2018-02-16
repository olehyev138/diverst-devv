require 'rails_helper'

RSpec.describe GroupCategory, type: :model do
   let(:group_category) { build(:group_category) }

  it{expect(group_category).to validate_presence_of(:name)}
  it{expect(group_category).to belong_to(:group_category_type)}
  it{expect(group_category).to have_many(:groups)}
end
