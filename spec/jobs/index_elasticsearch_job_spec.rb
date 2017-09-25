require 'rails_helper'

RSpec.describe IndexElasticsearchJob, elasticsearch: true, type: :job, :skip => true do
  let!(:user) { create(:user) }
  let!(:index_name) { User.es_index_name(enterprise: user.enterprise) }

  context 'when indexing user' do
    it "should add the index on Elasticsearch" do
      IndexElasticsearchJob.perform_now(model_name: 'User',operation: 'index',index: index_name,record_id: user.id)
      User.__elasticsearch__.refresh_index!(index: index_name)

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq user.id
    end
  end

  context 'when updating an user' do
    before :each do
      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', index: index_name, record_id: user.id)
    end

    it "should update the index on Elasticsearch" do
      User.__elasticsearch__.refresh_index!(index: index_name)
      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "first_name")).
        to eq user.first_name

      user.update(first_name: "New name")
      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'update', index: index_name, record_id: user.id)
      User.__elasticsearch__.refresh_index!(index: index_name)

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "first_name")).
        to eq "New name"
    end
  end

  context 'when deleting an user' do
    before :each do
      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', index: index_name, record_id: user.id)
    end

    it "should delete the index from Elasticsearch" do
      User.__elasticsearch__.refresh_index!(index: index_name)
      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq user.id

      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'delete', index: index_name, record_id: user.id)
      User.__elasticsearch__.refresh_index!(index: index_name)

      expect(Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits", 0, "_source", "id")).
        to eq nil
    end
  end

  context 'when trying to do an unknown action' do
    it "should raise an argument error" do
      expect {
        IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'unknown', index: index_name, record_id: user.id)
      }.to raise_error(ArgumentError)
    end
  end
end
