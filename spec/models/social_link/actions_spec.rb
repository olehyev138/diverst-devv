require 'rails_helper'

RSpec.describe SocialLink::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) { [
                            :author,
                            author:
                                [:field_data,
                                 :enterprise,
                                 :user_groups,
                                 :user_role,
                                 :news_links,
                                 :avatar_attachment,
                                 :avatar_blob,
                                 enterprise: [:theme, :mobile_fields],
                                 field_data: [:field, field: [:field_definer]]
                                 ]
                            ]
    }
    it { expect(SocialLink.base_preloads).to eq base_preloads }
  end
end
