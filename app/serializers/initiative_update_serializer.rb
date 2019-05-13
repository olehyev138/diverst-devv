class InitiativeUpdateSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :comments,
             :owner_id,
             :info
end
