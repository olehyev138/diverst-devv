require 'rails_helper'

RSpec.describe NewsLink::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) do
      [
          :author,
          :group,
          :comments,
          :photos,
          :picture_attachment, :picture_blob,
          {
              comments: [
                  :author,
                  :group,
                  author: [:avatar_attachment, :avatar_blob]
              ]
          }
      ]
    end

    it { expect(NewsLink.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end
end
