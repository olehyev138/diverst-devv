class InitiativeCommentPolicy < GroupBasePolicy
  def index?
    InitiativePolicy.new(user, record).show?
  end

  def update?
    record.user == user || manage_comments?
  end

  def create?
    index?
  end

  def destroy?
    update?
  end
end
