class CampaignPolicy < ApplicationPolicy
  def index?
    @policy_group.campaigns_index?
  end

  def create?
    @policy_group.campaigns_create?
  end

  class Scope < Scope
    def resolve
      return scope.all if @policy_group.campaigns_manage?
      scope.where(owner_id: user.id)
    end
  end
end
