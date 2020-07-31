require 'rails_helper'

RSpec.describe Activity::Actions, type: :model do
  describe 'valid_scopes' do
    let!(:valid_scopes) { %w(joined_from joined_to for_group_ids) }
    it { expect(Activity.valid_scopes).to eq valid_scopes }
  end

  describe 'base_includes' do
    let!(:base_includes) { [:owner] }
    it { expect(Activity.base_includes).to eq base_includes }
  end

  describe 'base_preloads' do
    let!(:base_preloads) { [:owner, { owner:
                                           [:field_data,
                                            :enterprise,
                                            :user_groups,
                                            :user_role,
                                            :news_links,
                                            :avatar_attachment,
                                            :avatar_blob,
                                            { enterprise: [:theme, :mobile_fields], field_data: [:field, { field: [:field_definer] }] }
                                           ] } ]
    }
    it { expect(Activity.base_preloads).to eq base_preloads }
  end

  describe 'ClassMethods' do
    let!(:group) { create(:group, name: 'test') }
    let!(:activity) { create(:activity) }

    describe 'csv_attributes' do
      it 'returns csv attributes' do
        expect(Activity.csv_attributes.dig(:titles)).to eq %w(User_id First_name Last_name Trackable_id Trackable_type Action Created_at)
      end
    end

    describe 'parameter_name' do
      it 'returns parameter name for scope for_group_ids' do
        expect(Activity.parameter_name(['for_group_ids', [group.id]])).to eq "of groups #{group.name}"
      end
      it 'returns parameter name for scope joined_to' do
        expect(Activity.parameter_name(['joined_to', Date.tomorrow])).to eq "to #{Date.tomorrow.strftime('%Y-%m-%d')}"
      end
      it 'returns parameter name for scope joined_from' do
        expect(Activity.parameter_name(['joined_from', Date.yesterday])).to eq "from #{Date.yesterday.strftime('%Y-%m-%d')}"
      end
    end

    describe 'file_name' do
      it 'returns file name' do
        expect(Activity.file_name({ query_scopes: [['joined_from', Date.yesterday], ['joined_to', Date.tomorrow], ['for_group_ids', [group.id]]] })).to\
      eq "from_#{Date.yesterday.strftime('%Y-%m-%d')}_to_#{Date.tomorrow.strftime('%Y-%m-%d')}_of_groups_#{group.name}_Logs"
      end
    end
  end
end
