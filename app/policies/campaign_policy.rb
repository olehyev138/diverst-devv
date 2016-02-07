class CampaignPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    false
  end

  def create?
    true
  end

  def edit?
    true
  end

  def destroy?
    true
  end
end
