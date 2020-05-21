require 'rails_helper'

RSpec.describe SponsorPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:sponsor) { create(:sponsor) }

  subject { described_class }

  permissions :sponsor_message_visibility? do
    it 'allows access to user with correct permissions' do
      sponsor.disable_sponsor_message = false
      expect(subject).to permit(user, sponsor)
    end

    it 'denies access to user with incorrect permissions' do
      sponsor.disable_sponsor_message = true
      expect(subject).to_not permit(user, sponsor)
    end
  end
end
