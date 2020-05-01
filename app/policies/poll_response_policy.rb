class PollResponsePolicy < ApplicationPolicy
  def poll_policy
    @poll_policy ||= if PollResponse === record
                       record.poll
                     else
                       PollPolicy.new(user, Poll.find_by(params[:poll_id]))
                     end
  end

  def index?
    poll_policy.show?
  end

  def create?
    PollResponse.find_by(user: user, poll_id: params[:poll_id]).none?
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    false
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
