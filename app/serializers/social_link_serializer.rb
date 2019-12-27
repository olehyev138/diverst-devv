class SocialLinkSerializer < ApplicationRecordSerializer
  attributes :author, :url

  def serialize_all_fields
    true
  end
end
