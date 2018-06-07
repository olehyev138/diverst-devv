require 'rails_helper'

RSpec.describe PolicyGroup, type: :model do
    describe 'test associations' do
        let(:policy_group) { build(:policy_group) }
        it{ expect(policy_group).to belong_to(:user)}
    end
end
