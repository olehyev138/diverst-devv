class InitiativeCommentPolicy < GroupBasePolicy
  def create?
    manage_comments?
  end

  def destroy?
    create?
  end
end
