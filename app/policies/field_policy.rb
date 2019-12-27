class FieldPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def index?
      FieldPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.joins(
            'LEFT JOIN enterprises ON enterprises.id = field_definer_id AND field_definer_type = \'Enterprise\' '\
            'LEFT JOIN polls ON polls.id = field_definer_id AND field_definer_type = \'Poll\' '\
            'LEFT JOIN groups ON groups.id = field_definer_id AND field_definer_type = \'Group\' '\
            'LEFT JOIN initiatives ON initiatives.id = field_definer_id AND field_definer_type = \'Initiative\' '\
            'LEFT JOIN groups init_groups ON initiatives.owner_group_id = init_groups.id '\
          ).where(
            'CASE '\
            'WHEN field_definer_type = \'Enterprise\' THEN field_definer_id '\
            'WHEN field_definer_type = \'Poll\' THEN polls.enterprise_id '\
            'WHEN field_definer_type = \'Group\' THEN groups.enterprise_id '\
            'WHEN field_definer_type = \'Initiative\' THEN init_groups.enterprise_id '\
            'ELSE -1 '\
            'END '\
            '= ?', user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
