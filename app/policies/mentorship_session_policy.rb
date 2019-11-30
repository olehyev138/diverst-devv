class MentorshipSessionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if manage_all?

    @record.user_id = @user.id
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def accept?
    # Can only accept if it's pending AND they're not the creator of the session AND it is their invite
    @record.pending? && !creator? && @user.id == @record.user_id
  end

  def decline?
    accept?
  end

  def creator?
    @user.id == @record.mentoring_session.creator_id
  end

  class Scope < Scope
    def index?
      MentorshipSessionPolicy.new(@user, nil).index?
    end

    def resolve
      scope.joins(:mentoring_session).where(
        mentoring_sessions: {
          enterprise_id: @user.enterprise.id
        },
      )
    end
  end
end
