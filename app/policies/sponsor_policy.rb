class SponsorPolicy < ApplicationPolicy
  def sponsor_message_visibility?
    !@record.disable_sponsor_message
  end

  def index?
    if params[:query_scopes]&.include?('group_sponsor')
      Group.find(params[:sponsorable_id]).show?
    else
      true
    end
  end

  def update?
    case @record.sponsorable_type
    when 'Group'
      GroupPolicy.new(user, @record.sponsorable, params).update?
    when 'Enterprise'
      EnterprisePolicy.new(user, @record.sponsorable, params).update_branding?
    else
      false
    end
  end

  def create?
    create_params = params[:sponsor]
    case create_params[:sponsorable_type]
    when 'Group'
      GroupPolicy.new(user, Group.find(create_params[:sponsorable_id]), params).update?
    when 'Enterprise'
      EnterprisePolicy.new(user, Enterprise.find(create_params[:sponsorable_id]), params).update_branding?
    else
      false
    end
  end
end
