class UpdatePolicy < ApplicationPolicy
  def parent_member_policy?(action)
    policy = "#{record.updatable_type}Policy".constantize rescue nil
    policy ? policy.new(user, record.updatable_type).send(action) : false
  end

  def parent_collection_policy?(action)
    parent = record.scope.instance_variable_get('@association').owner.class rescue nil
    if parent.present?
      policy = "#{parent}UpdatePolicy".constantize rescue nil
      policy ? policy.new(user, nil).send(action) : false
    end
  end

  def index?
    parent_collection_policy?(:index?)
  end

  def update?
    parent_member_policy?(:update?)
  end

  def destroy?
    parent_member_policy?(:update?)
  end

  def show?
    parent_member_policy?(:update?)
  end

  class Scope < Scope
    def index?
      UpdatePolicy.new(user, scope).index?
    end

    def resolve
      if index?
        scope.joins(
            'LEFT JOIN groups ON groups.id = updatable_id AND updatable_type = \'Group\' '\
            'LEFT JOIN initiatives ON initiatives.id = updatable_id AND updatable_type = \'Initiative\' '\
            'LEFT JOIN groups init_groups ON initiatives.owner_group_id = init_groups.id '\
          ).where(
            'CASE '\
            'WHEN updatable_type = \'Group\' THEN groups.enterprise_id '\
            'WHEN updatable_type = \'Initiative\' THEN init_groups.enterprise_id '\
            'ELSE -1 '\
            'END '\
            '= ?', user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
