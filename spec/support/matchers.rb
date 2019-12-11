# Attached file matcher for ActiveStorage
RSpec::Matchers.define :have_attached_file do |name|
  match do |record|
    file = record.send(name)
    file.respond_to?(:attach)
  end
end

# Validate attached file prescence matcher for ActiveStorage
RSpec::Matchers.define :validate_attachment_presence do |name|
  match do |record|
    record.send(name).purge # Delete attachment
    record.valid? # Rerun validations
    record.errors[:"#{name}"].present? # Check for validation error when attachment isn't present
  end
end

# Validate attached file content type matcher for ActiveStorage
# content_types & excluded_content_types: Accepts an array of content_type strings
# not_content_types is optional:
#   if you leave it empty, it verifies that all common content types (excluding passed valid `content_types`) are invalid
#   if you pass in an array of content types, it will verify that those content types are invalid
#   if you pass false, it does not verify that other content types are invalid at all
#
# Note: 'common content types' are defined in AttachmentHelper
RSpec::Matchers.define :validate_attachment_content_type do |name, content_types, excluded_content_types = nil|
  not_content_types =
    case excluded_content_types
    when false then false
    when nil then AttachmentHelper.common_types - content_types
    else excluded_content_types
    end

  match do |record|
    file_path = "#{Rails.root}/spec/fixtures/files/empty_file"
    file_name = 'empty_file'

    content_types.each do |content_type|
      record.send(name).attach(
        io: File.open(file_path),
        filename: file_name,
        content_type: content_type
      )
      record.valid?

      return false if record.errors[:"#{name}"].present?
    end

    return true unless not_content_types

    not_content_types.each do |not_content_type|
      record.send(name).attach(
        io: File.open(file_path),
        filename: file_name,
        content_type: not_content_type
      )
      record.valid?

      return false if record.errors[:"#{name}"].blank?
    end
  end
  description do
    desc = "validate that attachment content types for :#{name} are #{content_types}"
    desc << " and aren't #{not_content_types}" if not_content_types
    desc
  end
end
