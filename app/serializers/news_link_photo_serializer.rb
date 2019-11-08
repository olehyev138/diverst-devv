class NewsLinkPhotoSerializer < ApplicationRecordSerializer
  attributes :file_location

  def file_location
    object.file_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def serialize_all_fields
    true
  end
end
