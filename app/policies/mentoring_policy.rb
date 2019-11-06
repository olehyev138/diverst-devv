class MentoringPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if update?

    record.mentee_id == user.id || record.mentor_id == user.id
  end

  def edit?
    show?
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def delete_mentorship?
    show?
  end
end
