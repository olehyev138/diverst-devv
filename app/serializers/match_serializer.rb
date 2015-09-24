class MatchSerializer < ConversationSerializer
  attributes :expires_soon

  def expires_soon
    object.expires_soon?
  end
end
