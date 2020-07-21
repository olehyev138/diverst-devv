require 'rails_helper'

RSpec.describe GroupSerializer, type: :serializer do
  before do
    @enterprise = create(:enterprise)
    @group_category = create(:group_category, enterprise: @enterprise)
    @group_category_type = create(:group_category_type, enterprise: @enterprise)
    @group = create(:group, logo: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' },
                            banner: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' }, enterprise: @enterprise,
                            group_category_id: @group_category.id, group_category_type_id: @group_category_type.id,
                            annual_budget: 1000)
    create(:group, enterprise: @group.enterprise, parent_id: @group.id)
    create(:group, enterprise: @group.enterprise, parent_id: @group.id)
    @group.reload
  end

  it 'returns associations' do
    serializer = GroupSerializer.new(
        @group,
        scope: serializer_scopes(create(:user)),
        scope_name: :scope
      )

    expect(serializer.serializable_hash[:enterprise_id]).to eq(@enterprise.id)
    expect(serializer.serializable_hash[:group_category]).to_not be nil
    expect(serializer.serializable_hash[:group_category_type]).to_not be nil
    expect(serializer.serializable_hash[:banner]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget_leftover]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget_approved]).to be nil
    expect(serializer.serializable_hash[:annual_budget_available]).to be nil
    expect(serializer.serializable_hash[:currency]).to be nil
  end

  it 'returns associations for budgets and children' do
    serializer = GroupSerializer.new(
        @group,
        scope: serializer_scopes(create(:user)),
        scope_name: :scope,
        budgets: true,
        with_children: true
      )

    expect(serializer.serializable_hash[:enterprise_id]).to eq(@enterprise.id)
    expect(serializer.serializable_hash[:group_category]).to be nil
    expect(serializer.serializable_hash[:group_category_type]).to be nil
    expect(serializer.serializable_hash[:banner]).to be nil
    expect(serializer.serializable_hash[:annual_budget]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget_leftover]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget_approved]).to_not be nil
    expect(serializer.serializable_hash[:annual_budget_available]).to_not be nil
    expect(serializer.serializable_hash[:currency]).to_not be nil
  end
end
