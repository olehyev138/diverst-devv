require 'rails_helper'

RSpec.describe FolderSerializer, type: :serializer do
  it 'returns name field but not password_digest' do
    folder = create(:folder)
    serializer = FolderSerializer.new(folder)

    expect(serializer.serializable_hash[:name]).to eq folder.name
    expect(serializer.serializable_hash[:password_digest]).to be nil
  end
end