class SponsorSerializer < ApplicationRecordSerializer
  attributes :group, :enterprise, :sponsor_media_location, :sponsor_name, :sponsor_title, :sponsorable_id, :sponsorable_type, :permissions,
             :sponsor_media, :sponsor_media_file_name, :sponsor_media_data

  def serialize_all_fields
    true
  end

  def sponsor_media
    AttachmentHelper.attachment_signed_id(object.sponsor_media)
  end

  def sponsor_media_file_name
    AttachmentHelper.attachment_file_name(object.sponsor_media)
  end

  def sponsor_media_data
    AttachmentHelper.attachment_data_string(object.sponsor_media)
  end
end
