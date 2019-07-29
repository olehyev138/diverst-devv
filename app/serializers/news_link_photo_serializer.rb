class NewsLinkPhotoSerializer < ApplicationRecordSerializer
  attributes :file_location

  def serialize_all_fields
    true
  end
end
