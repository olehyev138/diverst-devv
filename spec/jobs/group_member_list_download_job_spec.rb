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
    end
end
