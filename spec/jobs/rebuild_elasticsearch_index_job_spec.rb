require 'rails_helper'

RSpec.describe RebuildElasticsearchIndexJob, type: :job do
  include ActiveJob::TestHelper

  before {
    client = OpenStruct.new({ indices: OpenStruct.new({ delete: true, create: true }) })
    @object = double('__elasticsearch__', settings: {}, index_name: true, import: true, client: client)
    allow(User).to receive(:__elasticsearch__).and_return(@object)
    allow(@object).to receive(:import).and_return(true)
    allow(client.indices).to receive(:delete).and_return(true)
    allow(client.indices).to receive(:create).and_return(true)
  }

  context 'when rebuilding user index' do
    it 'should add the index on Elasticsearch' do
      subject.perform('User')
      expect(@object).to have_received(:import)
    end
  end
end
