require 'rails_helper'

RSpec.describe PollMailer, type: :mailer do
  describe '#invitation' do
    let(:user) { create :user }
    let(:poll) { create :poll }
    let!(:group) { create :group }
    let!(:groups_poll) { create :groups_poll, :poll => poll, :group => group }
    let!(:mail) { described_class.invitation(poll, user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("You are Invited to participate in a '#{poll.title}' survey for members of #{group.name}")
    end
  end
end
