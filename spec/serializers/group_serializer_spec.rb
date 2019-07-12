require 'rails_helper'

RSpec.describe GroupSerializer, type: :serializer do
  it 'returns associations' do
    enterprise = create(:enterprise)
    group_category = create(:group_category, enterprise: enterprise)
    group_category_type = create(:group_category_type, enterprise: enterprise)
    group = create(:group, enterprise: enterprise, group_category_id: group_category.id, group_category_type_id: group_category_type.id)
    create(:group, enterprise: group.enterprise, parent_id: group.id)
    create(:group, enterprise: group.enterprise, parent_id: group.id)

    serializer = GroupSerializer.new(group)

    expect(serializer.serializable_hash[:enterprise_id]).to eq(enterprise.id)
    expect(serializer.serializable_hash[:group_category]).to_not be nil
    expect(serializer.serializable_hash[:group_category_type]).to_not be nil
  end
end
