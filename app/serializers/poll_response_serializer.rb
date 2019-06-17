class PollResponseSerializer < ActiveModel::Serializer
  attributes :id, :poll_id, :user_id, :data, :created_at, :updated_at, :anonymous
end
