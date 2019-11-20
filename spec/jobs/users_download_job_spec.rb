require 'rails_helper'

RSpec.describe UsersDownloadJob, type: :job do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }


  describe '#perform' do
    context 'for all users' do
      it 'creates a downloadable csv file for all users' do
        expect { subject.perform(user.id, 'all_users') }
          .to change(CsvFile, :count).by(1)
      end

      it 'file name is all_users.csv' do
        subject.perform(user.id, 'all_users')
        expect(CsvFile.last.download_file.filename.to_s).to eq 'all_users.csv'
      end
    end

    context 'for all active users' do
      it 'creates a downloadable csv file for only active users' do
        expect { subject.perform(user.id, 'active_users') }
          .to change(CsvFile, :count).by(1)
      end

      it 'file name is active_users.csv' do
        subject.perform(user.id, 'active_users')
        expect(CsvFile.last.download_file.filename.to_s).to eq 'active_users.csv'
      end
    end

    context 'for all inactive users' do
      it 'creates a downloadable csv file for inactive users' do
        expect { subject.perform(user.id, 'inactive_users') }
          .to change(CsvFile, :count).by(1)
      end

      it 'file name is inactive_users.csv' do
        subject.perform(user.id, 'inactive_users')
        expect(CsvFile.last.download_file.filename.to_s).to eq 'inactive_users.csv'
      end
    end

    context 'for users by role' do
      let(:role_name) { user.user_role.role_name }

      it 'creates a downloadable csv file for users by role' do
        expect { subject.perform(user.id, "#{role_name}") }
            .to change(CsvFile, :count).by(1)
      end

      it 'file name is user_role_name.csv' do
        subject.perform(user.id, "#{role_name}")
        expect(CsvFile.last.download_file.filename.to_s).to eq "#{role_name.split(' ').join('_')}.csv"
      end
    end
  end
end
