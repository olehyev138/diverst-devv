class InitiativeCommentPolicy < InitiativeBasePolicy
  def index?
    case record
    when GroupMessageComment then InitiativePolicy.new(user, record.initiative, params).show?
    else InitiativePolicy.new(user, InitiativePolicy, params).show?
    end
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
