require 'rails_helper'

RSpec.describe GroupMessage::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) do
      [
          :owner,
          :group,
          :comments,
          {
              comments: [
                  :author,
                  :group,
                  author: [:avatar_attachment, :avatar_blob]
              ]
          }
      ]
    end

    it { expect(GroupMessage.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end
