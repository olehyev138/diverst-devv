class BudgetProcedureService
  def self.refresh_budget_users_sums
    connection.execute('TRUNCATE TABLE `budget_users_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budget_users_sums`
      SELECT `budget_user_id`, SUM(`amount`) as spent
      FROM `initiative_expenses`
      GROUP BY `budget_user_id`;
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_budget_items_sums
    connection.execute('TRUNCATE TABLE `budget_users_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budget_items_sums`
      SELECT
        `budget_item_id`,
        SUM(`spent`) as spent,
        SUM(`reserved`) as reserved,
        SUM(`final_expense`) as finalized_expenditures
      FROM `budget_users_with_expenses`
      GROUP BY `budget_item_id`;
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_budgets_sums
    connection.execute('TRUNCATE TABLE `budget_users_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budgets_sums`
      SELECT
        `budget_id`,
        SUM(`spent`) as spent,
        SUM(`reserved`) as reserved,
        SUM(`estimated_amount`) as requested_amount,
        SUM(`available`) as available,
        SUM(`unspent`) as unspent
      FROM `budget_items_with_expenses`
      GROUP BY `budget_id`;
    SQL
                      )
  ensure
    connection.close
  end

  def self.refresh_annual_budgets_sums
    connection.execute('TRUNCATE TABLE `budget_users_sums`;')
    connection.execute(<<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `annual_budgets_sums`
      SELECT
        `annual_budget_id`,
        SUM(`spent`) as spent,
        SUM(`reserved`) as reserved,
        SUM(`requested_amount`) as requested_amount,
        SUM(`available`) as available,
        SUM(`approved_amount`) as approved,
        SUM(`unspent`) as unspent
      FROM `budgets_with_expenses`
      GROUP BY `annual_budget_id`;
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
