require 'rails_helper'

RSpec.describe ResourceSerializer, type: :serializer do
  let(:enterprise) { create(:enterprise) }
  let(:folder) { create(:folder) }
  let(:group) { create(:group) }
  let(:initiative) { create(:initiative) }
  let(:mentoring_session) { create(:mentoring_session) }

  let(:enterprise_resource) { create(:resource_with_file, enterprise: enterprise, folder: nil, group: nil, initiative: nil, mentoring_session: nil) }
  let(:folder_resource) { create(:resource_with_file, enterprise: nil, folder: folder, group: nil, initiative: nil, mentoring_session: nil) }
  let(:group_resource) { create(:resource_with_file, enterprise: nil, folder: nil, group: group, initiative: nil, mentoring_session: nil) }
  let(:event_resource) { create(:resource_with_file, enterprise: nil, folder: nil, group: nil, initiative: initiative, mentoring_session: nil) }
  let(:session_resource) { create(:resource_with_file, enterprise: nil, folder: nil, group: nil, initiative: nil, mentoring_session: mentoring_session) }

  let(:enterprise_resource_serializer) { ResourceSerializer.new(enterprise_resource, scope: serializer_scopes(create(:user))) }
  let(:folder_resource_serializer) { ResourceSerializer.new(folder_resource, scope: serializer_scopes(create(:user))) }
  let(:group_resource_serializer) { ResourceSerializer.new(group_resource, scope: serializer_scopes(create(:user))) }
  let(:event_resource_serializer) { ResourceSerializer.new(event_resource, scope: serializer_scopes(create(:user))) }
  let(:session_resource_serializer) { ResourceSerializer.new(session_resource, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :enterprise_resource_serializer
  include_examples 'permission container', :folder_resource_serializer
  include_examples 'permission container', :group_resource_serializer
  include_examples 'permission container', :event_resource_serializer
  include_examples 'permission container', :session_resource_serializer

  it 'returns fields and enterprise but not other associations' do
    serializer = enterprise_resource_serializer

    expect(serializer.serializable_hash[:id]).to eq(enterprise_resource.id)
    expect(serializer.serializable_hash[:enterprise]).to_not be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and folder but not other associations' do
    serializer = folder_resource_serializer

    expect(serializer.serializable_hash[:id]).to eq(folder_resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to_not be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and group but not other associations' do
    serializer = group_resource_serializer

    expect(serializer.serializable_hash[:id]).to eq(group_resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and initiative but not other associations' do
    serializer = event_resource_serializer

    expect(serializer.serializable_hash[:id]).to eq(event_resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to_not be nil
    expect(serializer.serializable_hash[:mentoring_session]).to be nil
  end

  it 'returns fields and mentoring_session but not other associations' do
    serializer = session_resource_serializer

    expect(serializer.serializable_hash[:id]).to eq(session_resource.id)
    expect(serializer.serializable_hash[:enterprise]).to be nil
    expect(serializer.serializable_hash[:file_location]).to_not be nil
    expect(serializer.serializable_hash[:folder]).to be nil
    expect(serializer.serializable_hash[:group]).to be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:mentoring_session]).to_not be nil
  end
end
