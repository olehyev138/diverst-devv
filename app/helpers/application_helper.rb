module ApplicationHelper
  def is_admin?
    current_admin
  end

  def back_to_diverst_path
    return groups_path if is_admin?
    employee_campaigns_path
  end
end
