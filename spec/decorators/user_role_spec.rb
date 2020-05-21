require 'rails_helper'

RSpec.describe UserRoleDecorator do
  let(:user_role) { create :user_role }

  describe '#default_role' do
    it 'returns Yes' do
      user_role.default = true
      decorated_user_role = user_role.decorate
      expect(decorated_user_role.default_role).to eq('Yes')
    end

    it 'returns No' do
      user_role.default = false
      decorated_user_role = user_role.decorate
      expect(decorated_user_role.default_role).to eq('No')
    end
  end
end
