class GroupDecorator < Draper::Decorator
  def spendings_percentage
    return 0 if group.spent_budget == 0

    return 100 unless group.annual_budget.present?
    return 100 if  group.annual_budget == 0

    (group.spent_budget || 0) / group.annual_budget * 100
  end
end