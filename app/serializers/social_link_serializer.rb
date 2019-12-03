class SocialLinkSerializer < ApplicationRecordSerializer
  attributes :group, :author, :url

  def serialize_all_fields
    true
  end
end
