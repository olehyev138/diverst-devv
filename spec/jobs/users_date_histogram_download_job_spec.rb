require 'rails_helper'

RSpec.describe UsersDateHistogramDownloadJob, type: :job do
    include ActiveJob::TestHelper

    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }

    describe "#perform" do
        before { User.__elasticsearch__.create_index!(index: User.es_index_name(enterprise: enterprise)) }
        after { User.__elasticsearch__.delete_index!(index: User.es_index_name(enterprise: enterprise)) }

        it "creates a downloadable csv file" do
            expect{ subject.perform(user.id, enterprise.id) }
              .to change(CsvFile, :count).by(1)
        end
    end
end
