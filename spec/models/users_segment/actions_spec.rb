require 'rails_helper'

RSpec.describe UsersSegment::Actions, type: :model do
  describe 'base_preloads' do
    let(:base_preloads) {
      [{:user=>[:field_data, :avatar_attachment, :avatar_blob, :user_role, {:field_data=>[:field, {:field=>[:field_definer]}]}]}]
    }

    it { expect(UsersSegment.base_preloads(Request.create_request(nil))).to eq base_preloads }
  end

  describe 'base_includes' do
    let(:base_includes) {
      [
          :user,
          :segment
      ]
    }

    it { expect(UsersSegment.base_includes(Request.create_request(nil))).to eq base_includes }
  end
end
