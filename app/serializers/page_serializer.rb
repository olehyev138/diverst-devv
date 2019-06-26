class PageSerializer < ApplicationRecordSerializer
  attributes :total, :type

  has_many :items
end
