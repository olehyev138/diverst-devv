require 'rails_helper'

RSpec.describe ResourceSerializer, type: :serializer do
  it 'returns fields and enterprise but not other associations' do
    enterprise = create(:enterprise)
    resource = create(:resource_with_file, enterprise: enterprise, folder: nil, group: nil, initiative: nil, mentoring_session: nil)

    serializer = ResourceSerializer.new(resource, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(resource.id)
    expect(serializer.serializable_hash[:enterprise]).to_not be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and folder but not other associations' do
    folder = create(:folder)
    resource = create(:resource_with_file, enterprise: nil, folder: folder, group: nil, initiative: nil, mentoring_session: nil)

    serializer = ResourceSerializer.new(resource, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to_not be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and group but not other associations' do
    group = create(:group)
    resource = create(:resource_with_file, enterprise: nil, folder: nil, group: group, initiative: nil, mentoring_session: nil)

    serializer = ResourceSerializer.new(resource, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and initiative but not other associations' do
    initiative = create(:initiative)
    resource = create(:resource_with_file, enterprise: nil, folder: nil, group: nil, initiative: initiative, mentoring_session: nil)

    serializer = ResourceSerializer.new(resource, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to_not be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and mentoring_session but not other associations' do
    mentoring_session = create(:mentoring_session)
    resource = create(:resource_with_file, enterprise: nil, folder: nil, group: nil, initiative: nil, mentoring_session: mentoring_session)

    serializer = ResourceSerializer.new(resource, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to_not be nil
  end
end
