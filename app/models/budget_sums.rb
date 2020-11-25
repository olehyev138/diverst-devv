class BudgetSums < ApplicationRecord
  self.table_name = 'budgets_sums'
  include MaterializedTable

  belongs_to :budget

  def readonly?
    true
  end

  def budget_inserted
    <<~SQL.gsub(/\s+/, ' ').strip
      INSERT INTO `budget_items_sums`
      #{Queries::BUDGET_ITEMS_SUMS.where('`budgets_sums`.`budget_id` = NEW.`id`').to_sql};
    SQL
  end

  def budget_deleted
    <<~SQL.gsub(/\s+/, ' ').strip
      DELETE FROM `budget_items_sums` WHERE `budgets_sums`.`budget_id` = OLD.`id`;
    SQL
  end
end
