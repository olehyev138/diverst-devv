require 'rails_helper'

RSpec.describe Notifiers::PollNotifier do
  let(:notifier){ Notifiers::PollNotifier.new(poll) }

  describe "when email was already sent" do
    let!(:poll){ create(:poll, email_sent: true) }

    it "should not sent emails" do
      expect(PollMailer).to receive(:delay).exactly(0).times
      notifier.notify!
    end
  end

  describe "when poll was not published" do
    let!(:poll){ create(:poll, status: "draft") }

    it "should not sent emails" do
      expect(PollMailer).to receive(:delay).exactly(0).times
      notifier.notify!
    end
  end

  describe "when poll was plublished" do
    let!(:poll){ create(:poll, status: "published", email_sent: false) }
    let!(:group){ create(:group, polls: [poll]) }
    let!(:users){ create_list(:user, 2, groups: [group]) }

    it "should send emails" do
      mailer = double("PollMailer")
      expect(PollMailer).to receive(:delay){ mailer }.exactly(2).times
      expect(mailer).to receive(:invitation).exactly(2).times
      notifier.notify!
    end

    it "should update poll" do
      notifier.notify!
      expect(poll.email_sent).to be_truthy
    end
  end
end
