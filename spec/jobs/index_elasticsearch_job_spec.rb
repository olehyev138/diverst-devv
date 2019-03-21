require 'rails_helper'

RSpec.describe IndexElasticsearchJob, type: :job do
  include ActiveJob::TestHelper
  let!(:index_name) { User.index_name }
  let!(:user) do
    perform_enqueued_jobs do
      create(:user)
    end
  end

  before(:each) do
    RefactorElasticsearchJob.perform_now
  end

  context 'when indexing user' do
    it "should add the index on Elasticsearch" do
      # We automatically create the index
      #IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', record_id: user.id)
      User.__elasticsearch__.refresh_index!

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq user.id
    end
  end

  context 'when updating an user' do
    before :each do
      # We automatically create the index
      #IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', record_id: user.id)
    end

    it "should update the index on Elasticsearch" do
      User.__elasticsearch__.refresh_index!
      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "first_name")).
        to eq user.first_name

      perform_enqueued_jobs do
        user.update(first_name: "New name")
      end
      # We automatically update the index
      #IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'update', record_id: user.id)
      User.__elasticsearch__.refresh_index!

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "first_name")).
        to eq "New name"
    end
  end

  context 'when deleting an user' do
    before :each do
      # We automatically create the index
      #IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', record_id: user.id)
    end

    it "should delete the index from Elasticsearch" do
      User.__elasticsearch__.refresh_index!
      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq user.id

      perform_enqueued_jobs do
        user.destroy
      end
      # We automatically delete the index
      #IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'delete', record_id: user.id)
      User.__elasticsearch__.refresh_index!

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq nil
    end
  end

  context 'when trying to do an unknown action' do
    it "should raise an argument error" do
      allow(Rollbar).to receive(:error)

      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'unknown', record_id: user.id)

      expect(Rollbar).to have_received(:error)
    end
  end
end
