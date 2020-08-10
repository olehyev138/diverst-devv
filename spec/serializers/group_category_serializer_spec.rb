require 'rails_helper'

RSpec.describe GroupCategorySerializer, type: :serializer do
  it 'returns associations' do
    enterprise = create(:enterprise)
    group_category_type = create(:group_category_type, enterprise: enterprise)
    group_category = create(:group_category, group_category_type_id: group_category_type.id, enterprise: enterprise)
    serializer = GroupCategorySerializer.new(group_category, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be_nil
    expect(serializer.serializable_hash[:name]).to_not be_nil
    expect(serializer.serializable_hash[:created_at]).to_not be_nil
    expect(serializer.serializable_hash[:updated_at]).to_not be_nil
    expect(serializer.serializable_hash[:enterprise_id]).to_not be_nil
    expect(serializer.serializable_hash[:group_category_type_id]).to_not be_nil
    expect(serializer.serializable_hash[:group_category_type]).to_not be_nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
