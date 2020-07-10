require 'rails_helper'

RSpec.describe UpdateSerializer, type: :serializer do
  it 'returns UpdateSerializer' do
    update = create(:update)
    serializer = UpdateSerializer.new(update, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:report_date]).to_not be nil
  end
end
