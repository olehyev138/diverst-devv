class InitiativeCommentPolicy < GroupBasePolicy
  def destroy?
    manage_comments?
  end
end
