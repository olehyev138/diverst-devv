class GlobalSettingsPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user

    @user = user
    @policy_group = @user.policy_group
  end

  def update?
    @policy_group.global_settings_manage?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
