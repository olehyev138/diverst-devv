require 'rails_helper'

RSpec.describe InviteUsersToGroupJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:invited_by) { create(:user, enterprise: enterprise) }

  it 'sends invitation email' do 
    mailer = double('mailer')

    expect(GroupInvitationMailer).to receive(:invitation) { mailer }
    expect(mailer).to receive(:deliver_later)
    subject.perform(group.id, user.id, invited_by.id)
  end

  it 'records points for user' do
    reward_action = create(:reward_action, label: 'Group invite',
                                           points: 8, 
                                           key: 'group_invite',
                                           enterprise: enterprise)
    mailer = double('mailer')

    subject.perform(group.id, user.id, invited_by.id)

    invited_by.reload
    expect(invited_by.points).to eq(reward_action.points)
  end
end
