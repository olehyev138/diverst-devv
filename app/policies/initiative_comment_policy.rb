class InitiativeCommentPolicy < GroupBasePolicy
  def index?
    InitiativePolicy.new(user, record).show?
  end

  def update?
    record.user == user
  end

  def create?
    manage_comments?
  end

  def destroy?
    create?
  end
end
