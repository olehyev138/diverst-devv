require 'rails_helper'

RSpec.describe SendPollNotificationJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }
  let!(:outcome) { create(:outcome, group: group) }
  let!(:pillar) { create(:pillar, outcome: outcome) }
  let!(:ended_initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar, start: 2.days.ago, end: Date.yesterday) }
  let!(:not_ended_initiative) { create(:initiative, owner_group_id: group.id, pillar: pillar, start: 2.days.ago, end: Date.today + 1.day) }
  let!(:poll_one) { create(:poll, status: 'published', email_sent: false, enterprise: enterprise, initiative: ended_initiative) }
  let!(:poll_two) { create(:poll, status: 'published', email_sent: true, enterprise: enterprise, initiative: ended_initiative) }
  let!(:poll_three) { create(:poll, status: 'published', email_sent: false, enterprise: enterprise, initiative: not_ended_initiative) }
  let!(:initiative_user) { create(:initiative_user, initiative: ended_initiative, user: create(:user, enterprise: enterprise)) }
  let!(:initiative_user) { create(:initiative_user, initiative: not_ended_initiative, user: create(:user, enterprise: enterprise)) }
  let!(:users) { create_list(:user, 2, enterprise: enterprise, groups: [group]) }

  it 'calls PollNotifier for concluded initiatives that does receives an email of a poll' do
    notifier = double('Notifiers::PollNotifier')
    expect(Notifiers::PollNotifier).to receive(:new) { notifier }.with(poll_one).exactly(1).times
    expect(notifier).to receive('notify!').exactly(1).times

    SendPollNotificationJob.perform_now
  end
end
