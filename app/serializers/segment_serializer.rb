class SegmentSerializer < ApplicationRecordSerializer
  attributes :owner, :active_users_filter, :limit, :permissions

  attributes_with_permission :all_rules_count, :field_rules, :order_rules, :group_rules, if: :show_action?

  def field_rules
    object.field_rules.map do |fr|
      SegmentFieldRuleSerializer.new(fr, **instance_options).as_json
    end
  end

  def order_rules
    object.order_rules.map do |orl|
      SegmentOrderRuleSerializer.new(orl, **instance_options).as_json
    end
  end

  def group_rules
    object.group_rules.map do |gr|
      SegmentGroupScopeRuleSerializer.new(gr, **instance_options).as_json
    end
  end

  def serialize_all_fields
    true
  end
end
