class InitiativeDecorator < Draper::Decorator
  decorates_association :updates

  def progress_percentage
    return nil if !initiative.start || !initiative.end
    return 100 if Time.current >= initiative.end

    (Time.current - initiative.start) / (initiative.end - initiative.start) * 100
  end

  def budget_percentage
    initiative_expences = initiative.expenses.sum(:amount).to_f

    # show red bar if expenses are greater than estimated_funding
    return 100 if initiative_expences > initiative.estimated_funding

    # Show empty bar if no funds is allocated
    return 0 if initiative.estimated_funding == 0

    # Show empty bar if expences is zero.
    return 0 if initiative_expences == 0

    return 100 if initiative_expences > initiative.estimated_funding

    initiative_expences / initiative.estimated_funding * 100
  end
end
