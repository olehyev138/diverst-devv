require 'rails_helper'

RSpec.describe Finders::Logs do
  context 'when filtering by groups' do
    before(:each) do
      PublicActivity.enabled = true
    end

    let(:group) { create(:group) }
    let(:initiative) { create(:initiative, owner_group: group) }
    let(:initiative_group) { create(:initiative_group, group: group) }
    let(:groups_poll) { create(:groups_poll, group: group) }
    let!(:initiative_log) { initiative.create_activity(:create) }
    let!(:initiative_group_log) { initiative_group.initiative.create_activity(:create) }
    let!(:poll_log) { groups_poll.poll.create_activity(:create) }
    let!(:group_log) { group.create_activity(:create) }
    let!(:another_log) { create(:user).create_activity(:create) }

    it 'return only logs of the groups' do
      finder = Finders::Logs.new(PublicActivity::Activity.all)
      expect(finder.filter_by_groups([group.id]).logs)
        .to match_array([initiative_log, initiative_group_log, poll_log, group_log])
    end
  end
end
