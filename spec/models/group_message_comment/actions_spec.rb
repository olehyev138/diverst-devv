require 'rails_helper'

RSpec.describe GroupMessageComment::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(GroupMessageComment.base_preloads.include?(:author)).to eq true }
    it { expect(GroupMessageComment.base_preloads.include?(author: [:field_data,
                                                                    :enterprise,
                                                                    :user_groups,
                                                                    :user_role,
                                                                    :news_links,
                                                                    :avatar_attachment,
                                                                    :avatar_blob,
                                                                    { enterprise: [:theme, :mobile_fields],
                                                                      field_data: [:field, { field: [:field_definer] }] }])).to eq true
    }
  end
end