class MetricsDashboardSerializer < ActiveModel::Serializer
  attributes :id, :enterprise_id, :name, :created_at, :updated_at, :owner_id, :shareable_token
end
