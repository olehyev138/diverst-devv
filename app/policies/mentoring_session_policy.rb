class MentoringSessionPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    update?
  end

  def update?
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

  def creator?
    @user.id == @record.creator_id
  end
end
