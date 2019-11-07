module AttachmentHelper
  COMMON_CONTENT_TYPES = {
    PNG: 'image/png',
    JPG: 'image/jpg',
    JPEG: 'image/jpeg',
    GIF: 'image/gif',
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
      COMMON_CONTENT_TYPES[:JPEG]
    ]
  end
end
