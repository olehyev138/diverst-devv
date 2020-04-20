class NewsLinkCommentSerializer < ApplicationRecordSerializer
  has_one :author
  def serialize_all_fields
    true
  end
end
