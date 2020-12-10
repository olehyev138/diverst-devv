class RefreshBudgetSumsJob < ApplicationJob
  queue_as :default

  def read_data
    {
        budget_users_sums: BudgetUserSums.order(:budget_user_id).as_json,
        budget_items_sums: BudgetItemSums.order(:budget_item_id).all.as_json,
        budgets_sums: BudgetSums.order(:budget_id).all.as_json,
        annual_budgets_sums: AnnualBudgetSums.order(:annual_budget_id).all.as_json,
    }
  end

  def perform(*args)
    old_data = read_data
    AnnualBudget.transaction do
      BudgetProcedureService.refresh_all_budgets_sums
    end
    new_data = read_data

    unless old_data == new_data
      diff = {}
      new_data.each do |k, v|
        changes = v - old_data[k]
        diff[k] = changes.map do |change|
          {
              old: old_data[k].find { |new| new[:id] = change[:id] },
              new: change
          }
        end
      end

      if Rails.env.development? || Rails.env.test?
        File.write("#{Rails.root}/log/budget_diff_#{Time.now}.json", diff.to_json)
      else
        e = StandardError.new("Budgets Desynced:\n#{diff.to_json}")
        Rollbar.warn(e)
      end
    end
  end
end
