require 'rails_helper'

RSpec.describe Activity::Actions, type: :model do
  describe 'valid_scopes' do
    it { expect(Activity.valid_scopes.include?('joined_from')).to eq true }
    it { expect(Activity.valid_scopes.include?('joined_to')).to eq true }
    it { expect(Activity.valid_scopes.include?('for_group_ids')).to eq true }
  end

  describe 'base_includes' do
    it { expect(Activity.base_includes.include?(:owner)).to eq true }
  end

  describe 'base_preloads' do
    it { expect(Activity.base_preloads.include?(:owner)).to eq true }
  end

  describe 'ClassMethods' do
    let!(:group) { create(:group, name: 'test') }
    let!(:activity) { create(:activity) }

    describe 'csv_attributes' do
      it { expect(Activity.csv_attributes.dig(:titles)).to eq %w(User_id First_name Last_name Trackable_id Trackable_type Action Created_at) }
    end

    describe 'parameter_name' do
      it { expect(Activity.parameter_name(['for_group_ids', [group.id]])).to eq "of groups #{group.name}" }
      it { expect(Activity.parameter_name(['joined_to', Date.tomorrow])).to eq "to #{Date.tomorrow.strftime('%Y-%m-%d')}" }
      it { expect(Activity.parameter_name(['joined_from', Date.yesterday])).to eq "from #{Date.yesterday.strftime('%Y-%m-%d')}" }
    end

    describe 'file_name' do
      it { expect(Activity.file_name({ query_scopes: [['joined_from', Date.yesterday], ['joined_to', Date.tomorrow], ['for_group_ids', [group.id]]] })).to\
      eq "from_#{Date.yesterday.strftime('%Y-%m-%d')}_to_#{Date.tomorrow.strftime('%Y-%m-%d')}_of_groups_#{group.name}_Logs"
      }
    end
  end
end
