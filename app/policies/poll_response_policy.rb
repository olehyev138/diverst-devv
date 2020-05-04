class PollResponsePolicy < ApplicationPolicy
  def poll_policy
    PollPolicy.new(user, poll)
  end

  def poll
    @poll ||= if PollResponse === record
      record.poll
    else
      Poll.find_by(id: (params[:poll_id] || params.dig(:poll_response, :poll_id)))
    end
  end

  def index?
    poll_policy.show?
  end

  def create?
    poll && poll.targeted_users.include?(user) && !poll.responses.exists?(user: user)
  end

  def update?
    manage_all? || record.user_id == user.id
  end

  def destroy?
    manage_all?
  end

  def show?
    index?
  end

  class Scope < Scope
    def index?
      PollPolicy.new(user, Poll.find_by(params[:poll_id])).show?
    end

    def resolve
      if index?
        scope.includes(:poll).where(polls: { enterprise_id: user.enterprise_id })
      else
        scope.none
      end
    end
  end

  private

  def scope_module_enabled?
    @user.enterprise.scope_module_enabled
  end
end
