class NewsLinkCommentSerializer < ApplicationRecordSerializer
  attributes :author

  has_one :author
  def serialize_all_fields
    true
  end
end
