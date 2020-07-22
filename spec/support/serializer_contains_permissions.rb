require 'rails_helper'

RSpec.shared_examples 'permission container' do |serializer_name|
  it "#{serializer_name} contains permission" do
    serializer = send(serializer_name)
    permissions = serializer.serializable_hash[:permissions]
    expect(permissions).to be_a Hash

    serialized_permission_keys = permissions.keys
    serializer_policies = serializer.policies

    serializer_policies.each do |policy|
      expect(serialized_permission_keys).to include policy
      expect(permissions[policy]).to_not be nil
    end
  end
end
