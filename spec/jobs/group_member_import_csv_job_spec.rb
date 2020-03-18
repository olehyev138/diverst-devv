require 'rails_helper'

RSpec.describe GroupMemberImportCSVJob, type: :job do
  context 'when pending_users is enabled' do
    let!(:user) { create(:user, email: 'test@gmail.com') }
    let!(:group) { create(:group, enterprise: user.enterprise, pending_users: 'enabled') }
    let!(:file) { { io: File.open('spec/fixtures/files/members.csv'), filename: 'members.csv' } }
    let!(:csv_file) { create(:csv_file, import_file: file, group_id: group.id, user: user) }

    xit 'imports the file and sends an email' do
      # TODO: fix this spec, shouldnt be using multiple expects to begin with
      pending 'fix this spec, shouldnt be using multiple expects to begin with'

      expect(group.members.count).to eq(0)

      subject.perform(csv_file.id)

      group.reload
      expect(group.members.count).to eq(1)
      expect(UserGroup.where(group_id: group.id, user_id: user.id, accepted_member: true).exists?).to be(false)
    end
  end

  context 'when pending_users is disabled' do
    let!(:user) { create(:user, email: 'test@gmail.com') }
    let!(:group) { create(:group, enterprise: user.enterprise, pending_users: 'disabled') }
    let!(:file) { fixture_file_upload('files/members.csv', 'text/csv') }
    let!(:csv_file) { create(:csv_file, import_file: file, group_id: group.id, user: user) }

    xit 'imports the file and sends an email' do
      # TODO: fix this spec, shouldnt be using multiple expects to begin with
      pending 'fix this spec, shouldnt be using multiple expects to begin with'

      expect(group.members.count).to eq(0)

      subject.perform(csv_file.id)

      group.reload
      expect(group.members.count).to eq(1)
      expect(UserGroup.where(group_id: group.id, user_id: user.id, accepted_member: true).exists?).to be(true)
    end
  end
end
