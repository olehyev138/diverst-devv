require 'rails_helper'

RSpec.describe GroupMessageComment::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [:author, :group, author: :avatar_attachment, :avatar_blob]
    }

    it { expect(GroupMessageComment.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end
