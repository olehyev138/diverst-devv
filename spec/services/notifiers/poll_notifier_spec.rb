require 'rails_helper'

RSpec.describe Notifiers::PollNotifier do
  let(:notifier){ Notifiers::PollNotifier.new(poll) }

  describe "when email was already sent" do
    let!(:poll){ create(:poll, email_sent: true) }

    it "should not sent emails" do
      call_mailer_exactly(0)
      notifier.notify!
    end
  end

  describe "when poll was not published" do
    let!(:poll){ create(:poll, status: "draft") }

    it "should not sent emails" do
      call_mailer_exactly(0)
      notifier.notify!
    end
  end

  describe "when poll was plublished" do
    let!(:poll){ create(:poll, status: "published", email_sent: false) }
    let!(:group){ create(:group, polls: [poll]) }
    let!(:users){ create_list(:user, 2, groups: [group]) }

    it "should send emails" do
      call_mailer_exactly(2)
      notifier.notify!
    end

    it "should update poll" do
      notifier.notify!
      expect(poll.email_sent).to be_truthy
    end
  end

  def call_mailer_exactly(n)
    mailer = double("PollMailer")
    expect(PollMailer).to receive(:delay){ mailer }.exactly(n).times
    expect(mailer).to receive(:invitation).exactly(n).times
  end
end
