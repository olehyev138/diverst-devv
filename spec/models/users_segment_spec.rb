require 'rails_helper'

RSpec.describe UsersSegment, type: :model do
  let(:users_segment) { build_stubbed(:users_segment) }

  describe 'test associations' do
    it{ expect(users_segment).to belong_to(:user) }
    it{ expect(users_segment).to belong_to(:segment) }
  end
end