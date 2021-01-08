require 'rails_helper'

RSpec.describe PageSerializer, type: :serializer do
  it 'returns page' do
    users = create_list(:user, 6)
    page = Page.new(User.all, 6, nil)
    serializer = PageSerializer.new(page, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:total]).to eq  6
    expect(serializer.serializable_hash[:items]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end