class ApplicationRecordSerializer < ActiveModel::Serializer
  include BaseSerializer

  attributes

  def attributes
    hash = super
    hash.merge!(serialized_keys)
    hash
  end
end
