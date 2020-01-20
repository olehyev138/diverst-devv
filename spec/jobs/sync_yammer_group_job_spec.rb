require 'rails_helper'

RSpec.describe SyncYammerGroupJob, type: :job do
  describe '#perform' do
    it 'subscribes the user to the group' do
      enterprise = create(:enterprise, yammer_import: true, yammer_token: 'token')
      group = create(:group, enterprise: enterprise)
      user = create(:user, enterprise: enterprise)
      create(:user_group, group: group, user: user)

      yammer = double('YammerClient')
      allow(YammerClient).to receive(:new).and_return(yammer)
      allow(yammer).to receive(:user_with_email).and_return({ 'id' => 1, 'yammer_token' => nil })
      allow(yammer).to receive(:token_for_user).and_return({ 'token' => 'token' })
      allow(yammer).to receive(:subscribe_to_group)

      SyncYammerGroupJob.new.perform(group.id)

      expect(yammer).to have_received(:subscribe_to_group)
    end
  end
end
