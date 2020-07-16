require 'rails_helper'

RSpec.describe UsersSegment::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(UsersSegment.base_preloads.include?({ segment: [:field_rules, :order_rules, :group_rules, { field_rules: [:field, { field: [:field_definer] }] }],
                                                      user: [:field_data,
                                                             :enterprise,
                                                             :user_groups,
                                                             :user_role,
                                                             :news_links,
                                                             :avatar_attachment,
                                                             :avatar_blob,
                                                             { enterprise: [:theme, :mobile_fields], field_data: [:field, { field: [:field_definer] }] }] })).to eq true }
  end

  describe 'base_includes' do
    it { expect(UsersSegment.base_includes.include?(:user)).to eq true }
    it { expect(UsersSegment.base_includes.include?(:segment)).to eq true }
  end
end
