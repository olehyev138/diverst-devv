require 'rails_helper'

RSpec.describe SocialLink::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [:author]
    }

    it { expect(SocialLink.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end
