require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { create :user }

  describe '#active_status' do
    it 'returns Active' do
      user.active = true
      decorated_user = user.decorate
      expect(decorated_user.active_status).to eq('Active')
    end

    it 'returns Inactive' do
      user.active = false
      decorated_user = user.decorate
      expect(decorated_user.active_status).to eq('Inactive')
    end
  end
end
