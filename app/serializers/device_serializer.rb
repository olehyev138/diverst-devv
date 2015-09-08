class DeviceSerializer < ActiveModel::Serializer
  attributes :id,
    :platform,
    :token
end
