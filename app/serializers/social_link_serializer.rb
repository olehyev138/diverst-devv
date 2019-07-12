class SocialLinkSerializer < ApplicationRecordSerializer
  attributes :group, :author

  def serialize_all_fields
    true
  end
end
