class NewsLinkSerializer < ApplicationRecordSerializer
  attributes :group, :author, :photos
  
  def serialize_all_fields
    true
  end
end
