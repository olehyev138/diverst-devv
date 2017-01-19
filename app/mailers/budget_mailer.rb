class BudgetMailer < ApplicationMailer
  def approve_request(budget, receiver)
    @receiver = receiver
    @budget = budget
    @group = budget.subject
    @approve_url = view_budget_group_url(@group, budget_id: @budget.id)

    mail(to: @receiver.email, subject: subject(@group.name))
  end

  private

  def subject(group_name)
    "You are asked to review budget for #{group_name} ERG group"
  end
end
