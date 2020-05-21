class ExceptionSerializer < ActiveModel::Serializer
  attributes :id,
             :message
end
