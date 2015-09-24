class MatchSerializer < ConversationSerializer
  attributes :expires_soon

  def expires_soon
    expires_soon?
  end
end
