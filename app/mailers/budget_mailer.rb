class BudgetMailer < ApplicationMailer
  def approve_request(budget, receiver)
    @receiver = receiver
    @budget = budget
    @group = budget.subject
    @enterprise_id = @group.enterprise.id

    url = group_budget_url(@group, @budget)
    @mailer_text = @group.enterprise.approve_budget_request_mailer_notification_text  % { user_name: receiver.name, budget_name: @group.name, click_here: "<a saml_for_enterprise=\"#{@enterprise_id}\" href=\"#{url}\" target=\"_blank\">Click here</a>" }

    mail(to: @receiver.email, subject: subject(@group.name))
  end

  def budget_approved(budget)
    @budget = budget
    @group = budget.subject
    
    url = group_budget_url(@group, @budget)
    @mailer_text = @group.enterprise.budget_approved_mailer_notification_text  % { user_name: budget.requester.name, budget_name: @group.name, click_here: "<a saml_for_enterprise=\"#{@group.enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>" }

    mail(to: budget.requester.email, subject: "The budget for #{ budget.subject.name } was approved")
  end

  def budget_declined(budget)
    @budget = budget
    @group = budget.subject
    
    url = group_budget_url(@group, @budget)
    @mailer_text = @group.enterprise.budget_declined_mailer_notification_text  % { user_name: budget.requester.name, budget_name: @group.name, click_here: "<a saml_for_enterprise=\"#{@group.enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>" }
    
    mail(to: budget.requester.email, subject: "The budget for #{ budget.subject.name } was declined")
  end

  private

  def subject(group_name)
    "You are asked to review budget for #{group_name} ERG group"
  end
end
