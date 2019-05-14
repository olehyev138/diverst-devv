require 'rails_helper'

RSpec.describe YammerClient, type: :service do
  describe '#users' do
    it 'returns 200' do
      token = 'token'
      url = 'https://www.yammer.com/api/v1/users.json'
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:get, url).with(headers: headers).to_return(status: 200)

      response = YammerClient.new(token).users

      expect(response.code).to eq(200)
    end
  end

  describe '#groups' do
    it 'returns 200' do
      token = 'token'
      url = 'https://www.yammer.com/api/v1/groups.json'
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:get, url).with(headers: headers).to_return(status: 200)

      response = YammerClient.new(token).groups

      expect(response.code).to eq(200)
    end
  end

  describe '#create_group' do
    it 'returns 200' do
      token = 'token'
      url = 'https://www.yammer.com/api/v1/groups.json'
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:post, url).with(body: {}, headers: headers).to_return(status: 200)

      response = YammerClient.new(token).create_group({})

      expect(response.code).to eq(200)
    end
  end

  describe '#token_for_user' do
    it 'returns 200' do
      token = 'token'
      user_id = 1
      url = "https://www.yammer.com/api/v1/oauth/tokens.json?consumer_key=#{ENV['YAMMER_CLIENT_ID']}&user_id=#{user_id}"
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:get, url).with(body: {}, headers: headers).to_return(status: 200)

      response = YammerClient.new(token).token_for_user(user_id: user_id)

      expect(response.code).to eq(200)
    end
  end

  describe '#user_with_email' do
    it 'returns 200' do
      token = 'token'
      email = 'test@gmail.com'
      url = "https://www.yammer.com/api/v1/users/by_email.json?email=#{email}"
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:get, url).with(body: {}, headers: headers).to_return(status: 200)

      response = YammerClient.new(token).user_with_email(email)

      expect(response.code).to eq(200)
    end
  end

  describe '#current_user' do
    it 'returns 200' do
      token = 'token'
      url = 'https://www.yammer.com/api/v1/users/current.json'
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:get, url).with(body: {}, headers: headers).to_return(status: 200)

      response = YammerClient.new(token).current_user

      expect(response.code).to eq(200)
    end
  end

  describe '#subscribe_to_group' do
    it 'returns 200' do
      token = 'token'
      group_id = 1
      url = "https://www.yammer.com/api/v1/group_memberships.json?group_id=#{group_id}"
      headers = { 'Authorization' => "Bearer #{token}" }

      stub_request(:post, url).with(body: {}, headers: headers).to_return(status: 200)

      response = YammerClient.new(token).subscribe_to_group(group_id)

      expect(response.code).to eq(200)
    end
  end

  describe '#user_fields' do
    it 'returns correct array' do
      fields = ['id', 'network_id', 'state', 'guid', 'location', 'significant_other',
                'kids_names', 'interests', 'summary', 'expertise', 'full_name', 'activated_at',
                'auto_activated', 'show_ask_for_photo', 'first_name', 'last_name', 'network_name', 'url',
                'web_url', 'name', 'mugshot_url', 'mugshot_url_template', 'birth_date', 'timezone', 'admin',
                'verified_admin', 'supervisor_admin', 'can_broadcast', 'department', 'email',
                'can_create_new_network', 'can_browse_external_networks', 'show_invite_lightbox']

      expect(YammerClient.user_fields).to eq(fields)
    end
  end
end
