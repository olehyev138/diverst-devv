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

  # Attachment data encoded in base64, useful for rendering the attachment as an image on deserialization
  def self.attachment_data_string(attachment)
    Base64.encode64(attachment.download) if attachment.attached?
  end

  # Attachment content type
  def self.attachment_content_type(attachment)
    attachment.content_type if attachment.attached?
  end
end
