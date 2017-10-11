require 'rails_helper'

RSpec.describe RebuildElasticsearchIndexJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:user_one) { create(:user, enterprise: enterprise) }
  let!(:user_two) { create(:user, enterprise: enterprise) }
  let!(:index_name) { User.es_index_name(enterprise: enterprise) }

  before(:each) do
    IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'index', index: index_name, record_id: user_one.id)
    User.__elasticsearch__.refresh_index!(index: index_name)
  end

  it "should update all users on elasticsearch" do
    expect(
      Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits").collect{ |r| r.dig("_source", "first_name") }
    ).to eq [user_one.first_name]

    RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
    User.__elasticsearch__.refresh_index!(index: index_name)

    expect(
      Elasticsearch::Model.client.search(index: index_name).dig("hits", "hits").collect{ |r| r.dig("_source", "first_name") }
    ).to match_array([user_one.first_name, user_two.first_name])
  end
end
