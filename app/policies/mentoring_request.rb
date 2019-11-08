class MentoringRequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if manage_all?

    record.sender_id == @user.id || record.receiver_id == @user.id
  end

  def edit?
    return true if manage_all?

    record.sender_id == @user.id
  end

  def create?
    false
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def accept?
    return true if manage_all?

    record.sender_id == @user.id
  end

  def deny?
    accept?
  end

  class Scope < Scope
    def index?
      MentoringRequestPolicy.new(@user, nil).index?
    end

    def resolve
      scope.joins(:sender).where(
        users: {
          enterprise_id: @user.enterprise.id
        },
      )
    end
  end
end
