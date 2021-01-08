class AdminGroupBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :coded_id, :permissions

  attributes_with_permission :name, :short_description, :description, :parent_id, :parent_coded_id, :budget_type,
                             :private, :enterprise_id, :children, :annual_budget_leftover, :budget_manager_id,
                             :annual_budget, :annual_budget_approved, :annual_budget_available, :aggregate, if: :show?

  def show?
    policy&.show?
  end

  def budget_manager_id
    if head?
      object.id
    else
      case budget_type
      when :all then object.id
      when :region, :parent then object.parent_id
      else nil
      end
    end
  end

  def annual_budget
    annual_budget_object.amount
  end

  def aggregate
    head? && budget_type != :all
  end

  def head?
    object.is_a?(Group) && object.parent_id == nil
  end

  def annual_budget_object
    @annual_budget ||= if head? && budget_type == :region
      object.current_aggregate_budget_data
    else
      object.current_annual_budget
    end
  end

  def enterprise_id
    case object
    when Group then object.enterprise_id
    when Region then object.parent.enterprise_id
    else nil
    end
  end

  [:leftover, :approved, :available].each do |method|
    define_method "annual_budget_#{method}" do
      annual_budget_object.send(method)
    end
  end

  def parent_coded_id
    unless head?
      object.parent.coded_id
    end
  end

  def budget_type
    AnnualBudget.current_aggregate_type
  end

  def budget_children
    if head?
      case budget_type
      when :all
        object.children
      when :region
        object.regions
      when :parent
        object.children.none
      else nil
      end
    end
  end

  def children
    budget_children&.map do |child|
      AdminGroupBudgetSerializer.new(child, budget_type: budget_type, **instance_options).as_json
    end
  end

  def policies
    [
      :annual_budgets_manage?,
      :carryover_annual_budget?,
      :reset_annual_budget?,
      :budget_owner?,
      :budget_super?,
      :parent_budgets?,
    ]
  end

  def current_user_is_member
    scope&.dig(:current_user)&.is_member_of?(object)
  end
end
