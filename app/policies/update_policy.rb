class UpdatePolicy < ApplicationPolicy
  def parent_policy
    case record
    when Update then record_parent_policy
    when Class, NilClass then params_parent_policy
    else nil
    end
  end

  def record_parent_policy
    case record.updatable_type
    when 'Group' then GroupUpdatePolicy.new(user, [record.updatable, record])
    when 'Initiative' then InitiativeUpdatePolicy.new(user, record)
    else nil
    end
  end

  def params_parent_policy
    if params[:group_id]
      GroupUpdatePolicy.new(user, record, params)
    elsif params[:initiative_id]
      InitiativeUpdatePolicy.new(user, record, params)
    else
      nil
    end
  end

  delegate :index?, :update?, :destroy?, :show?, :create?, to: :parent_policy

  def prototype?
    create?
  end

  class Scope < Scope
    def self.parent_scope(params)
      if params[:group_id]
        GroupUpdatePolicy::Scope
      elsif params[:initiative_id]
        InitiativeUpdatePolicy::Scope
      else
        nil
      end
    end

    def self.new(user, scope, permission = nil, params: {})
      parent_scope(params)&.new(user, scope, permission, params: params) || super
    end
  end
end
