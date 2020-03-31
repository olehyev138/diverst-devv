require 'rails_helper'

RSpec.describe FieldSerializer, type: :serializer do
  it 'returns fields' do
    field = create(:field)
    serializer = FieldSerializer.new(field, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq field.id
    expect(serializer.serializable_hash[:title]).to eq field.title
  end
end
