require 'rails_helper'

RSpec.describe GroupMemberImportCSVJob, type: :job do
    let!(:user) {create(:user, :email => "test@gmail.com")}
    let!(:group) {create(:group, :enterprise => user.enterprise)}
    let!(:file) { fixture_file_upload('files/members.csv', 'text/csv') }
    let!(:csv_file){ create(:csv_file, :import_file => file, :group_id => group.id, :user => user) }

    it "imports the file and sends an email" do
        expect(group.members.count).to eq(0)
        
        subject.perform(csv_file.id)
        
        group.reload
        expect(group.members.count).to eq(1)
    end
end
