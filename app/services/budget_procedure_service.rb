class BudgetProcedureService
  class Queries
    # Queries to Calculate the proper sums for the budget models
    BUDGET_USERS_SUMS = InitiativeExpense.select(
        :budget_user_id,
        'SUM(`amount`) as spent'
      ).group(:budget_user_id)
    BUDGET_ITEMS_SUMS = BudgetUser.select(
        :budget_item_id,
        'SUM(`spent`) as spent',
        'SUM(`reserved`) as reserved',
        'SUM(`user_estimate`) as user_estimates',
        'SUM(`final_expense`) as finalized_expenditures'
      ).from(BudgetUser.with_expenses).group(:budget_item_id)
    BUDGET_SUMS = BudgetItem.select(
        :budget_id,
        'SUM(`spent`) as spent',
        'SUM(`reserved`) as reserved',
        'SUM(`user_estimates`) as user_estimates',
        'SUM(`finalized_expenditures`) as finalized_expenditures',
        'SUM(`estimated_amount`) as requested_amount',
      ).from(BudgetItem.with_expenses).group(:budget_id)
    ANNUAL_BUDGETS_SUMS = Budget.select(
        :annual_budget_id,
        'SUM(`spent`) as spent',
        'SUM(`reserved`) as reserved',
        'SUM(`user_estimates`) as user_estimates',
        'SUM(`finalized_expenditures`) as finalized_expenditures',
        'SUM(`requested_amount`) as requested_amount',
        'SUM(`approved_amount`) as approved',
      ).from(Budget.with_expenses).group(:annual_budget_id)
  end

  # Methods to delete the old sums, then add back the correct sums
  def self.refresh_budget_users_sums
    connection.execute('TRUNCATE TABLE `budget_users_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budget_users_sums`
      #{Queries::BUDGET_USERS_SUMS.to_sql};
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_budget_items_sums
    connection.execute('TRUNCATE TABLE `budget_items_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budget_items_sums`
      #{Queries::BUDGET_ITEMS_SUMS.to_sql};
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_budgets_sums
    connection.execute('TRUNCATE TABLE `budgets_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budgets_sums`
      #{Queries::BUDGET_SUMS.to_sql};
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_annual_budgets_sums
    connection.execute('TRUNCATE TABLE `annual_budgets_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `annual_budgets_sums`
      #{Queries::ANNUAL_BUDGETS_SUMS.to_sql};
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_all_budgets_sums
    refresh_budget_users_sums
    refresh_budget_items_sums
    refresh_budgets_sums
    refresh_annual_budgets_sums
  end

  def self.connection
    ActiveRecord::Base.connection
  end
end
