require 'rails_helper'

RSpec.describe PollResponse do

  describe 'test associations' do
    let!(:poll_response) { build_stubbed(:poll_response) }

    it { expect(poll_response).to belong_to(:poll) }
    it { expect(poll_response).to belong_to(:user) }
  end

  describe 'when describing callbacks' do
    it "should index user on elasticsearch after create" do
      poll_response = build(:poll_response)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'index',
          index: User.es_index_name(enterprise: poll_response.poll.enterprise),
          record_id: poll_response.user.id
        )
        poll_response.save
      end
    end

    it "should reindex user on elasticsearch after update" do
      poll_response = create(:poll_response)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: poll_response.poll.enterprise),
          record_id: poll_response.user.id
        )
        poll_response.update(anonymous: false)
      end
    end

    it "should remove user from elasticsearch after destroy" do
      poll_response = create(:poll_response)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'delete',
          index: User.es_index_name(enterprise: poll_response.poll.enterprise),
          record_id: poll_response.user.id
        )
        poll_response.destroy
      end
    end
  end
end
