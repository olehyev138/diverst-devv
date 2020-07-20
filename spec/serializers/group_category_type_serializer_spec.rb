require 'rails_helper'

RSpec.describe GroupCategoryTypeSerializer, type: :serializer do
  it 'returns associations' do
    enterprise = create(:enterprise)
    group_category_type = create(:group_category_type, enterprise: enterprise)
    serializer = GroupCategoryTypeSerializer.new(group_category_type, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be_nil
    expect(serializer.serializable_hash[:name]).to_not be_nil
    expect(serializer.serializable_hash[:created_at]).to_not be_nil
    expect(serializer.serializable_hash[:updated_at]).to_not be_nil
    expect(serializer.serializable_hash[:enterprise_id]).to_not be_nil
  end
end
