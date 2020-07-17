require 'rails_helper'

RSpec.describe GroupMessage::Actions, type: :model do
  describe 'base_preloads' do
    it { expect(GroupMessage.base_preloads.include?(:owner)).to eq true }
    it { expect(GroupMessage.base_preloads.include?(:group)).to eq true }
    it { expect(GroupMessage.base_preloads.include?(:comments)).to eq true }
    it { expect(GroupMessage.base_preloads.include?(comments: [:author,
                                                               { author: [:field_data,
                                                                          :enterprise,
                                                                          :user_groups,
                                                                          :user_role,
                                                                          :news_links,
                                                                          :avatar_attachment,
                                                                          :avatar_blob,
                                                                          { enterprise: [:theme, :mobile_fields],
                                                                            field_data: [:field, { field: [:field_definer] }] }] }],
                                                    group: [:enterprise],
                                                    owner: [:field_data,
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
