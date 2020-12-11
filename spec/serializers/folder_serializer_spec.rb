require 'rails_helper'

RSpec.describe FolderSerializer, type: :serializer do
  let(:folder) { create(:folder) }
  let(:serializer) { FolderSerializer.new(folder, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns name field but not password_digest' do
    expect(serializer.serializable_hash[:name]).to eq folder.name
    expect(serializer.serializable_hash[:password_digest]).to be nil
    expect(serializer.serializable_hash[:permissions]&.keys).to eq [:show?, :update?, :destroy?, :archive?]
  end

  include_examples 'preloads serialized data', :folder
end
