require 'rails_helper'

RSpec.describe Notifiers::PollNotifier do
  let(:notifier) { Notifiers::PollNotifier.new(poll) }

  describe 'when email was already sent' do
    let!(:poll) { create(:poll, email_sent: true) }

    it 'should not sent emails' do
      call_mailer_exactly(0)
      notifier.notify!
    end
  end

  describe 'when poll was not published' do
    let!(:poll) { create(:poll, status: 'draft') }

    it 'should not sent emails' do
      call_mailer_exactly(0)
      notifier.notify!
    end
  end

  describe 'when poll was plublished' do
    context 'when there is not an initiative on poll' do
      let!(:poll) { create(:poll, status: 'published', email_sent: false) }
      let!(:users) { create_list(:user, 2, enterprise: poll.enterprise) }
      let!(:group) { create(:group, polls: [poll], members: users) }

      it 'should send emails to all users' do
        call_mailer_exactly(2)
        notifier.notify!
      end

      it 'should update poll' do
        notifier.notify!
        expect(poll.email_sent).to be_truthy
      end
    end

    context 'when there is an initiative on poll' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise: enterprise) }
      let!(:outcome) { create(:outcome, group: group) }
      let!(:pillar) { create(:pillar, outcome: outcome) }
      let!(:initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar) }
      let!(:poll) { create(:poll, status: 'published', email_sent: false, enterprise: enterprise, initiative: initiative) }
      let!(:initiative_user) { create(:initiative_user, initiative: initiative, user: create(:user, enterprise: poll.enterprise)) }
      let!(:users) { create_list(:user, 2, enterprise: poll.enterprise, groups: [group]) }

      context 'and initiative was ended up' do
        before(:each) { initiative.update(end: Date.yesterday) }

        it 'should send emails to users of initiative' do
          call_mailer_exactly(1)
          notifier.notify!
        end

        it 'should update poll' do
          notifier.notify!
          expect(poll.email_sent).to be_truthy
        end
      end

      context 'and initiative was not ended up' do
        before(:each) { initiative.update(end: Date.today + 1.day) }

        it 'should not send emails to users of initiative' do
          call_mailer_exactly(0)
          notifier.notify!
        end

        it 'should not update poll' do
          notifier.notify!
          expect(poll.email_sent).to be_falsy
        end
      end
    end
  end

  def call_mailer_exactly(n)
    mailer = double('PollMailer')
    expect(PollMailer).to receive(:invitation) { mailer }.exactly(n).times
    expect(mailer).to receive(:deliver_later).exactly(n).times
  end
end
