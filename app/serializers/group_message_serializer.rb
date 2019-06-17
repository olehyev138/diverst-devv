class GroupMessageSerializer < ActiveModel::Serializer
  attributes :id, :group_id, :subject, :content, :created_at, :updated_at, :owner_id
end
