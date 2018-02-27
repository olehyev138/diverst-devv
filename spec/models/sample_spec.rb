require 'rails_helper'

RSpec.describe Sample, type: :model do

    describe 'validations' do
        let(:sample) { FactoryGirl.build_stubbed(:sample) }

        it{ expect(sample).to validate_presence_of(:user_id) }
    end

    describe 'commit' do
        it "indexes on create" do
            allow(IndexElasticsearchJob).to receive(:perform_later).and_call_original
            user = create(:user)
            sample = Sample.new(:user_id => user.id, :data => user.data)
            sample.save
            expect(IndexElasticsearchJob).to have_received(:perform_later).exactly(2).times
        end

        it "indexes on update" do
            allow(IndexElasticsearchJob).to receive(:perform_later)
            first_user = create(:user)

            sample = Sample.new(:user_id => first_user.id, :data => first_user.data)
            sample.save!

            second_user = create(:user)

            sample = Sample.find(sample.id)
            sample.user_id = second_user.id
            sample.data = second_user.data
            sample.save

            expect(IndexElasticsearchJob).to have_received(:perform_later).exactly(4).times
        end

        it "indexes on destroy" do
            allow(IndexElasticsearchJob).to receive(:perform_later)
            first_user = create(:user)

            sample = Sample.new(:user_id => first_user.id, :data => first_user.data)
            sample.save!

            sample.destroy

            expect(IndexElasticsearchJob).to have_received(:perform_later).exactly(4).times
        end
    end
end
