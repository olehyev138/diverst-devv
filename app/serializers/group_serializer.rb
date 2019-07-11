class GroupSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description

  has_many :children
end
