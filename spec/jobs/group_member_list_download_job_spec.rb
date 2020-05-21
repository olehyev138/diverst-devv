require 'rails_helper'

RSpec.describe GroupMemberListDownloadJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:group) { create(:group, enterprise: enterprise) }

  describe '#perform' do
    context 'for all members' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, group.id, 'all_members') }
          .to change(CsvFile, :count).by(1)
      end

      it 'suffix of download file name is (all_members)' do
        subject.perform(user.id, group.id, 'all_members')
        expect(CsvFile.last.download_file_name).to eq "#{group.file_safe_name}_membership_list(all_members)"
      end
    end

    context 'for all active members' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, group.id, 'active_members') }
          .to change(CsvFile, :count).by(1)
      end

      it 'suffix of download file name is (active_members)' do
        subject.perform(user.id, group.id, 'active_members')
        expect(CsvFile.last.download_file_name).to eq "#{group.file_safe_name}_membership_list(active_members)"
      end
    end

    context 'for all inactive members' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, group.id, 'inactive_members') }
          .to change(CsvFile, :count).by(1)
      end

      it 'suffix of download file name is (inactive_members)' do
        subject.perform(user.id, group.id, 'inactive_members')
        expect(CsvFile.last.download_file_name).to eq "#{group.file_safe_name}_membership_list(inactive_members)"
      end
    end

    context 'for all pending members' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, group.id, 'pending_members') }
          .to change(CsvFile, :count).by(1)
      end

      it 'suffix of download file name is (pending_members)' do
        subject.perform(user.id, group.id, 'pending_members')
        expect(CsvFile.last.download_file_name).to eq "#{group.file_safe_name}_membership_list(pending_members)"
      end
    end

    context 'for all group_parent_members' do
      it 'creates a downloadable csv file' do
        expect { subject.perform(user.id, group.id, 'group_parent_members') }
          .to change(CsvFile, :count).by(1)
      end

      it 'suffix of download file name is (group_parent_members)' do
        subject.perform(user.id, group.id, 'group_parent_members')
        expect(CsvFile.last.download_file_name).to eq "#{group.file_safe_name}_membership_list(group_parent_members)"
      end
    end

    context 'with fields to add' do
      # Paperclip.io_adapters.for(attachment.file).read
      let!(:number_y) { create(:numeric_field, enterprise: enterprise, add_to_member_list: true) }
      let!(:number_n) { create(:numeric_field, enterprise: enterprise) }

      let!(:date_y) { create(:date_field, enterprise: enterprise, add_to_member_list: true) }
      let!(:date_n) { create(:date_field, enterprise: enterprise) }

      let!(:check_y) { create(:checkbox_field, enterprise: enterprise, add_to_member_list: true) }
      let!(:check_n) { create(:checkbox_field, enterprise: enterprise) }

      let!(:select_y) { create(:select_field, enterprise: enterprise, add_to_member_list: true) }
      let!(:select_n) { create(:select_field, enterprise: enterprise) }

      let!(:user2) { create(:user, enterprise: enterprise) }

      before do
        data = '{'
        data += "\"#{number_y.id}\":25, \"#{number_n.id}\":75, "
        data += "\"#{date_y.id}\":#{Time.parse('2020-6-6').to_i}, \"#{date_n.id}\":#{Time.parse('2020-7-7').to_i}, "
        data += "\"#{check_y.id}\":[\"YES\", \"NO\"], \"#{check_n.id}\":[\"YES\", \"MAYBE\"], "
        data += "\"#{select_y.id}\":[\"maybe\"], \"#{select_n.id}\":[\"no\"]"
        data += '}'

        create(:user_group, user: user, group: group)
        create(:user_group, user: user2, group: group)

        user2.data = data
        user2.save
      end

      it 'show the allowed fields in the CSV' do
        subject.perform(user.id, group.id, 'all_members')
        text = Paperclip.io_adapters.for(CsvFile.last.download_file).read

        fields = %w(first_name last_name email_address) + [number_y.title, date_y.title, check_y.title, select_y.title]

        user2_data = "#{user2.first_name},#{user2.last_name},#{user2.email},"

        user1_data = "#{user.first_name},#{user.last_name},#{user.email},"
        user1_data += ',,,'

        expect(text).to include fields.join(',')

        expect(text).to include user1_data
        expect(text).to include user2_data

        expect(text).to include ',25,2020-06-06'
        expect(text).to include ",\"YES, NO\",maybe\n"
      end

      it 'doesn\'t show fields not allowed in CSV' do
        subject.perform(user.id, group.id, 'all_members')
        text = Paperclip.io_adapters.for(CsvFile.last.download_file).read

        expect(text).not_to include number_n.title
        expect(text).not_to include date_n.title
        expect(text).not_to include check_n.title
        expect(text).not_to include select_n.title

        expect(text).not_to include ',75,'
        expect(text).not_to include ',"YES, MAYBE",'
        expect(text).not_to include ",no\n"
        expect(text).not_to include ',2020-07-07,'
      end
    end
  end
end
