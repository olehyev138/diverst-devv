require 'rails_helper'

RSpec.describe GenericGraphsTopFoldersByViewsDownloadJob, type: :job do
    include ActiveJob::TestHelper

    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, :enterprise => enterprise) }

    describe "#perform" do
      context "demo" do
        it "creates a downloadable csv file" do
            expect{ subject.perform(user.id, enterprise.id, demo: true) }
              .to change(CsvFile, :count).by(1)
        end
      end

      context "non demo" do
        it "creates a downloadable csv file" do
            expect{ subject.perform(user.id, enterprise.id, demo: false) }
              .to change(CsvFile, :count).by(1)
        end
      end
    end
end