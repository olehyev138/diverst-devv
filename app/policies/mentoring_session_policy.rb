class MentoringSessionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if manage_all?

    creator? || invited_user?
  end

  def create?
    true
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    return true if manage_all?

    creator?
  end

  def destroy?
    update?
  end

  def join?
    accepted_user?
  end

  def start?
    accepted_user?
  end

  def create_comment?
    show?
  end

  def accepted_user?
    return true if creator?

    @record.mentorship_sessions.find_by(user_id: @user.id).accepted?
  end

  def invited_user?
    @record.mentorship_sessions.exists(user_id: @user.id)
  end

  def creator?
    @user.id == @record.creator_id
  end

  class Scope < Scope
    def index?
      MentoringSessionPolicy.new(@user, nil).index?
    end

    def resolve
      scope.where(
          enterprise_id: @user.enterprise.id
        )
    end
  end
end
