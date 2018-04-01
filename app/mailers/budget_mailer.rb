class BudgetMailer < ApplicationMailer
  def approve_request(budget, receiver)
    @receiver = receiver
    @budget = budget
    @group = budget.group
    @enterprise_id = @group.enterprise.id
    @approve_url = group_budget_url(@group, @budget)

    mail(to: @receiver.email, subject: subject(@group.name))
  end

  def budget_approved(budget)
    @budget = budget
    mail(to: budget.requester.email, subject: "The budget for #{ budget.group.name } was approved")
  end

  def budget_declined(budget)
    @budget = budget
    mail(to: budget.requester.email, subject: "The budget for #{ budget.group.name } was declined")
  end

  private

  def subject(group_name)
    "You are asked to review budget for #{group_name} ERG group"
  end
end
