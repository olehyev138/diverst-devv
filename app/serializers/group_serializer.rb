class GroupSerializer < ApplicationRecordSerializer
  attributes :id, :name, :short_description, :description

  belongs_to :parent
  # has_many :children
end