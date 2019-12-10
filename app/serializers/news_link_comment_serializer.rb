class NewsLinkCommentSerializer < ApplicationRecordSerializer
  belongs_to :author

  def serialize_all_fields
    true
  end
end
