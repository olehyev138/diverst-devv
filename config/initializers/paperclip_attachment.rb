# TODO Remove after Paperclip to ActiveStorage migration
# Note: Very non-ideal way to do this, but necessary for the migration
Paperclip::Attachment.class_eval do
  alias_method :old_initialize, :initialize

  def initialize(name, instance, options = {})
    old_initialize(name.to_s.chomp('_paperclip'), instance, options)
  end
end
