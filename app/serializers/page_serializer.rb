class PageSerializer < ActiveModel::Serializer
  attributes :total

  has_many :items

  def total
    object.total
  end
end
