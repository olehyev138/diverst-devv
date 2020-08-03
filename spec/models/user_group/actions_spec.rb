require 'rails_helper'

RSpec.describe UserGroup::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          :group,
          :user,
          group: [
              :news_feed,
              :annual_budgets,
              :logo_attachment,
              :banner_attachment,
              enterprise: [
                  :theme
              ]
          ],
          user: [
              :user_role,
              :enterprise,
              :news_links,
              :avatar_attachment,
              enterprise: [
                  :theme,
                  :mobile_fields
              ]
          ]
      ]
    }

    it { expect(UserGroup.base_preloads).to eq base_preloads }
  end

  describe 'base_includes' do
    let(:base_includes) {
      [
          :user,
          :group
      ]
    }

    it { expect(UserGroup.base_includes).to eq base_includes }
  end

  describe 'valid_scopes' do
    let(:valid_scopes) {
      %w(
          active
          pending
          inactive
          accepted_users
          all
          joined_from
          joined_to
          for_segment_ids
          user_search
      )
    }

    it { expect(UserGroup.valid_scopes).to eq valid_scopes }
  end

  describe 'csv_attributes' do
    let(:csv_attributes) {
      [
          'First name',
          'Last name',
          'Email',
          'Accepted',
          'Biography',
          'Active']
    }

    it { expect(UserGroup.csv_attributes.dig(:titles)).to eq csv_attributes }
  end

  let(:segment) { create(:segment, name: 'test segment') }
  let(:group) { create(:group, name: 'test group') }
  describe 'parameter_name' do
    it 'raises an exception' do
      expect { UserGroup.parameter_name({}) }.to raise_error(ArgumentError)
    end
    it { expect(UserGroup.parameter_name(['for_segment_ids', [segment.id]])).to eq "of segments #{segment.name}" }
    it { expect(UserGroup.parameter_name(['joined_to', Date.tomorrow])).to eq "to #{Date.tomorrow.strftime('%Y-%m-%d')}" }
    it { expect(UserGroup.parameter_name(['joined_from', Date.yesterday])).to eq "from #{Date.yesterday.strftime('%Y-%m-%d')}" }
    it { expect(UserGroup.parameter_name('all')).to eq 'all' }
    it { expect(UserGroup.parameter_name('active')).to eq 'active' }
    it { expect(UserGroup.parameter_name('pending')).to eq 'pending' }
    it { expect(UserGroup.parameter_name('inactive')).to eq 'inactive' }
    it { expect(UserGroup.parameter_name('accepted_users')).to eq 'accepted' }
  end

  describe 'file_name' do
    it 'raises an exception if group id is missing' do
      expect { UserGroup.file_name({}) }.to raise_error(ArgumentError)
    end
    it 'returns file name' do
      expect(UserGroup.file_name({ group_id: group.id, query_scopes: ['all', ['joined_from', Date.yesterday], ['joined_to', Date.tomorrow], ['for_segment_ids', [segment.id]]] })).to\
      eq "all_members_of_test_group_from_#{Date.yesterday.strftime('%Y-%m-%d')}_to_#{Date.tomorrow.strftime('%Y-%m-%d')}_of_segments_test_segment"
      expect(UserGroup.file_name({ group_id: group.id, query_scopes: ['accepted_users', ['joined_from', Date.yesterday], ['for_segment_ids', [segment.id]]] })).to\
      eq "accepted_members_of_test_group_from_#{Date.yesterday.strftime('%Y-%m-%d')}_of_segments_test_segment"
      expect(UserGroup.file_name({ group_id: group.id, query_scopes: ['active', ['joined_to', Date.tomorrow], ['for_segment_ids', [segment.id]]] })).to\
      eq "active_members_of_test_group_to_#{Date.tomorrow.strftime('%Y-%m-%d')}_of_segments_test_segment"
      expect(UserGroup.file_name({ group_id: group.id, query_scopes: ['pending', ['joined_from', Date.yesterday], ['joined_to', Date.tomorrow]] })).to\
      eq "pending_members_of_test_group_from_#{Date.yesterday.strftime('%Y-%m-%d')}_to_#{Date.tomorrow.strftime('%Y-%m-%d')}"
    end
  end
end
