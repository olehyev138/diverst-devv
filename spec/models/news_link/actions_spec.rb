require 'rails_helper'

RSpec.describe NewsLink::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) do
      [
          :author,
          :group,
          :comments,
          :photos,
          :picture_attachment,
          {
              comments: [
                  :author
              ]
          }
      ]

    end

    it { expect(NewsLink.base_preloads).to eq base_preloads }
  end
end
