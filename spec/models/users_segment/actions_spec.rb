require 'rails_helper'

RSpec.describe UsersSegment::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [
          segment: [:field_rules,
                    :order_rules,
                    :group_rules,
                    field_rules: [
                        :field,
                        field: [:field_definer]
                    ]
          ],
          user: [:field_data,
                 :enterprise,
                 :user_groups,
                 :user_role,
                 :news_links,
                 :avatar_attachment,
                 :avatar_blob,
                 enterprise: [
                     :theme,
                     :mobile_fields],
                 field_data: [
                     :field,
                     field: [:field_definer]
                 ]
          ]
      ]
    }

    it { expect(UsersSegment.base_preloads).to eq base_preloads }
  end

  describe 'base_includes' do
    let(:base_includes) {
      [
          :user,
          :segment
      ]
    }

    it { expect(UsersSegment.base_includes).to eq base_includes }
  end
end
