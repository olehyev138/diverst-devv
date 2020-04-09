require 'rails_helper'

RSpec.describe SyncYammerUsersJob, type: :job do
  describe '#perform' do
    it 'invites the user' do
      user = create(:user)
      allow(User).to receive(:from_yammer).and_return(user)
      allow(user).to receive(:invitation_instructions)

      create(:enterprise, yammer_import: true, yammer_token: 'token')

      token = 'token'
      url = 'https://www.yammer.com/api/v1/users.json'
      headers = { 'Authorization' => "Bearer #{token}" }

      yammer_user = { 'contact' => { 'email_addresses' => [{ 'address' => 'test@gmail.com' }] } }
      stub_request(:get, url).with(headers: headers).to_return(status: 200, body: [yammer_user])

      SyncYammerUsersJob.new.perform

      expect(user).to have_received(:invitation_instructions)
    end
  end
end
