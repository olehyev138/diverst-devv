require 'rails_helper'

RSpec.describe Notifiers::PollNotifier do
  let(:notifier) { Notifiers::PollNotifier.new(poll) }

  describe 'when email was already sent' do
    let!(:poll) { create(:poll, email_sent: true, user_poll_tokens: create_list(:user_poll_token, 4, email_sent: true)) }

    it 'should not sent emails' do
      create(:user_poll_token, email_sent: true, poll: poll)
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
      let!(:enterprise) { create(:enterprise) }
      let!(:users) { create_list(:user, 2, enterprise: enterprise) }
      let!(:group) { create(:group, members: users, enterprise: enterprise) }
      let!(:poll) { create(:poll, status: 'published', email_sent: false, groups: [group], enterprise: enterprise) }

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
      let!(:initiative) {
        create(
            :initiative,
            owner_group_id: group.id,
            pillar: pillar,
            initiative_users: [
                create(
                    :initiative_user,
                    user: create(
                        :user,
                        enterprise: enterprise,
                        groups: [group]
                    )
                )
            ]
        )
      }
      let!(:users) { create_list(:user, 2, enterprise: enterprise, groups: [group]) }
      let!(:poll) { create(:poll, status: 'published', email_sent: false, enterprise: enterprise, initiative: initiative) }

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
