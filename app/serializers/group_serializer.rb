class GroupSerializer < ActiveModel::Serializer
  attributes :id, :enterprise_id, :name, :description, :created_at, :updated_at, :manager_id, :owner_id
end
