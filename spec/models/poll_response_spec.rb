require 'rails_helper'

RSpec.describe PollResponse do
  it_behaves_like 'it Contains Field Data'

  describe 'test associations' do
    let(:poll_response) { build_stubbed(:poll_response) }

    it { expect(poll_response).to belong_to(:poll) }
    it { expect(poll_response).to belong_to(:user) }

    it { expect(poll_response).to validate_presence_of(:poll) }
    it { expect(poll_response).to validate_presence_of(:user) }
    it { expect(poll_response).to have_many(:user_reward_actions).dependent(:destroy) }
    it { expect(poll_response).to validate_length_of(:data).is_at_most(65535) }
  end

  describe '#group' do
    let!(:group) { create(:group) }
    let!(:initiative) { create(:initiative, owner_group_id: group.id) }
    let!(:poll) { build(:poll, initiative_id: initiative.id) }
    let!(:poll_response) { create(:poll_response) }

    it 'returns group' do
      poll_response.poll = poll
      expect(poll_response.group).to eq group
    end
  end

  describe 'when describing callbacks' do
    it 'should index user on elasticsearch after create', skip: true do
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

    it 'should reindex user on elasticsearch after update', skip: true do
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

    it 'should remove user from elasticsearch after destroy', skip: true do
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
