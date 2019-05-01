require 'rails_helper'

RSpec.describe UsersDownloadJob, type: :job do
    include ActiveJob::TestHelper

    describe "#perform" do
        it "creates a downloadable csv file for all users" do
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            
            expect{ subject.perform(user.id, "all_users") }
              .to change(CsvFile, :count).by(1)
        end

        it "creates a downloadable csv file for only active users" do
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)

            expect{ subject.perform(user.id, "active_users") }
              .to change(CsvFile, :count).by(1)
        end

        it "creates a downloadable csv file for inactive users" do
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)

            expect{ subject.perform(user.id, "inactive_users") }
              .to change(CsvFile, :count).by(1)
        end

        it "creates a downloadable csv file for group leaders" do
            enterprise = create(:enterprise)
            user = create(:user, :enterprise => enterprise)
            
            expect{ subject.perform(user.id,  "group_leaders") }
              .to change(CsvFile, :count).by(1)
        end
    end
end
