class BudgetMailer < ApplicationMailer
  def approve_request(budget, receiver)
    @user = receiver
    @budget = budget
    @group = budget.group
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(from: @from_address, to: @email, subject: @subject)
  end

  def budget_approved(budget)
    @budget = budget
    @group = budget.group
    @user = budget.requester
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(to: @email, subject: @subject)
  end

  def budget_declined(budget)
    @budget = budget
    @group = budget.group
    @user = budget.requester
    @enterprise = @group.enterprise
    return if @enterprise.disable_emails?

    @custom_text = @enterprise.custom_text rescue CustomText.new
    @email = @user.email_for_notification

    set_defaults(@enterprise, method_name)

    mail(to: @email, subject: @subject)
  end

  def variables
    {
      user: @user,
      group: @group,
      enterprise: @enterprise,
      budget: @budget,
      custom_text: @custom_text,
      click_here: "<a saml_for_enterprise=\"#{@enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>",
    }
  end

  def url
    group_budget_url(@group, @budget)
  end
end
