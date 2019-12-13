require 'rails_helper'

RSpec.describe IndexElasticsearchJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }

  before {
    @client = double('Client', delete: true)
    allow(Elasticsearch::Client).to receive(:new).and_return(@client)
    allow(@client).to receive(:delete)

    allow(Rails.env).to receive(:test?).and_return(false)
    @object = double('__elasticsearch__', index_document: true, update_document: true, document_type: true, index_name: true)
    allow_any_instance_of(User).to receive(:__elasticsearch__).and_return(@object)
    allow(User).to receive(:__elasticsearch__).and_return(@object)
    allow(@object).to receive(:index_document).and_return(true)
    allow(@object).to receive(:update_document).and_return(true)
  }

  context 'when indexing user' do
    it 'should add the index on Elasticsearch' do
      subject.perform(model_name: 'User', operation: 'index', record_id: user.id)
      expect(@object).to have_received(:index_document)
    end
  end

  context 'when updating an user' do
    it 'should update the index on Elasticsearch' do
      subject.perform(model_name: 'User', operation: 'update', record_id: user.id)
      expect(@object).to have_received(:update_document)
    end
  end

  context 'when deleting an user' do
    it 'should delete the index from Elasticsearch' do
      subject.perform(model_name: 'User', operation: 'delete', record_id: user.id)
      expect(@client).to have_received(:delete)
    end
  end

  context 'when trying to do an unknown action' do
    it 'should raise an argument error' do
      allow(Rollbar).to receive(:error)
      IndexElasticsearchJob.perform_now(model_name: 'User', operation: 'unknown', record_id: user.id)

      expect(Rollbar).to have_received(:error)
    end
  end
end
