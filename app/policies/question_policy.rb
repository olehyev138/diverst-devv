class QuestionPolicy < ApplicationPolicy
  attr_reader :campaign, :campaign_policy

  def initialize(user, context, params = {})
    super(user, context, params)
    # Check if it's a collection, a record, or a class
    if context.is_a?(Enumerable) # Collection/Enumerable
      @campaign = context.first
      @record = context.second
    elsif context.is_a?(Class) # Class
      # Set group using params if context is a class as this will be for
      # nested model actions such as index and create, which require a group
      @campaign = ::Campaign.find(params[:campaign_id] || params.dig(context.model_name.param_key.to_sym, :campaign_id)) rescue nil
    elsif context.present?
      @campaign = context.campaign
      @record = context
    end

    if campaign
      @campaign_policy = CampaignPolicy.new(user, campaign, params)
    end
  end

  def index?
    campaign_policy&.show?
  end

  def create?
    campaign_policy&.update?
  end

  def show?
    update?
  end

  def destroy?
    update?
  end

  delegate :manage?, :update?, to: :campaign_policy, allow_nil: true

  class Scope < Scope
    def index?
      policy.index?
    end

    def resolve
      if index?
        policy.campaign.present? ?
            scope.merge(policy.campaign.questions) :
            scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end

  private

  def collaborate_module_enabled?
    @user.enterprise.collaborate_module_enabled
  end
end
