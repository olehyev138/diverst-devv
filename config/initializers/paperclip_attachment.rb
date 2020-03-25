# TODO Remove after Paperclip to ActiveStorage migration
# Note: Very non-ideal way to do this, but necessary for the migration
Paperclip::Attachment.class_eval do
  alias_method :old_initialize, :initialize

  def initialize(name, instance, options = {})
    old_initialize(name.to_s.chomp('_paperclip'), instance, options)
  end
end

#Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
#Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-east-1.amazonaws.com'

