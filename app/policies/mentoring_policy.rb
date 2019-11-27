class MentoringPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if manage_all?

    record.mentee_id == user.id || record.mentor_id == user.id
  end

  def edit?
    show?
  end

  def create?
    manage_all?
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

  class Scope < Scope
    def index?
      MentoringPolicy.new(@user, nil).index?
    end

    def resolve
      scope.joins(:mentor).where(
        users: {
          enterprise_id: @user.enterprise.id
        },
      )
    end
  end
end
