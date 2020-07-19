require 'rails_helper'

RSpec.describe CustomTextSerializer, type: :serializer do
  it 'returns custom text' do
    custom_text = create(:custom_text)
    serializer = CustomTextSerializer.new(custom_text, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq custom_text.id
    expect(serializer.serializable_hash[:erg]).to eq custom_text.erg
    expect(serializer.serializable_hash[:program]).to eq custom_text.program
    expect(serializer.serializable_hash[:parent]).to eq custom_text.parent
    expect(serializer.serializable_hash[:sub_erg]).to eq custom_text.sub_erg
    expect(serializer.serializable_hash[:plural].key?('id')).to eq false
    expect(serializer.serializable_hash[:plural].key?('enterprise_id')).to eq false
  end
end
