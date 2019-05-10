class MentoringSessionCommentPolicy < ApplicationPolicy
  def update?
    creator?
  end

  def edit?
    update?
  end

  def destroy?
    creator?
  end

  def creator?
    @user.id == @record.user_id
  end
end
