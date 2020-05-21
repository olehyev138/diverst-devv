Paperclip.options[:content_type_mappings] = {
  csv: %w(text/plain text/csv)
}

Paperclip::Attachment.default_options[:validate_media_type] = false
