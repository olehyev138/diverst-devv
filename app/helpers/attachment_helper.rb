module AttachmentHelper
  COMMON_CONTENT_TYPES = {
    PNG: 'image/png',
    JPG: 'image/jpg',
    JPEG: 'image/jpeg',
    GIF: 'image/gif',
    SVG: 'image/svg+xml',
    PDF: 'application/pdf',
    CSV: 'text/csv',
    XML: 'text/xml',
    JSON: 'application/json',
    ZIP: 'application/zip',
    TEXT: 'text/plain',
    HTML: 'text/html',
  }

  def self.common_types
    COMMON_CONTENT_TYPES.values
  end

  def self.common_image_types
    [
      COMMON_CONTENT_TYPES[:PNG],
      COMMON_CONTENT_TYPES[:JPG],
      COMMON_CONTENT_TYPES[:JPEG],
      COMMON_CONTENT_TYPES[:SVG]
    ]
  end

  # Signed ID of the attachment, useful to use for the state value of the file input on an edit form
  def self.attachment_signed_id(attachment)
    attachment.signed_id if attachment.attached?
  end

  # Uploaded file name of the attachment, useful to use as the visual value of the file input for user feedback on an edit form
  def self.attachment_file_name(attachment)
    attachment.filename.to_s if attachment.attached?
  end

  # Attachment data encoded into a string for serialization
  def self.attachment_data_string(attachment)
    self.encode_data(attachment.download) if attachment.attached?
  end

  # Attachment content type
  def self.attachment_content_type(attachment)
    attachment.content_type if attachment.attached?
  end

  # Creates a resized image variant of the passed attachment with the upper limits of the passed width & height
  # and encodes it into a string for serialization.
  #
  # Note: When the variant is processed, ActiveStorage should upload it to the service so that the processing
  # doesn't happen every single time.
  def self.image_resize_variant_data_string(image_attachment, width, height)
    return nil unless image_attachment.attached?

    processed = image_attachment.variant(combine_options: {
        auto_orient: true,
        gravity: 'center',
        resize: "#{width}x#{height}^",
        crop: "#{width}x#{height}+0+0"
    }).processed

    self.encode_data(processed.service.download(processed.key))
  end

  # Encodes the passed in data in base64 for serialization
  def self.encode_data(data_to_encode)
    Base64.encode64(data_to_encode) if data_to_encode.present?
  end
end
