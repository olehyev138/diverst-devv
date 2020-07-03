require 'rails_helper'

RSpec.describe PageSerializer, type: :serializer do
  it 'returns activity' do
    activity = create(:page)
    serializer = PageSerializer.new(activity, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:owner_id]).to_not be nil
  end
end
