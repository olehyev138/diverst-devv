class CreationOfAnnualBudgetsAndMigrateBudgetDataToNewBudgetModel < ActiveRecord::Migration[5.2]
  def up
    create_table :annual_budgets do |t|
      t.references :group, index: true, foreign_key: true
      t.references :enterprise, index: true, foreign_key: true
      t.decimal :amount, default: 0.0
      t.boolean :closed, default: false
      t.decimal :available_budget, default: 0.0
      t.decimal :approved_budget, default: 0.0
      t.decimal :expenses, default: 0.0
      t.decimal :leftover_money, default: 0.0

      t.timestamps null: false
    end

    add_column :initiatives, :annual_budget_id, :integer
    add_column :budgets, :annual_budget_id, :integer
    add_column :initiative_expenses, :annual_budget_id, :integer

    say 'Created AnnualBudgets table'


    say 'Begin data migration into new AnnualBudget model...'

    #NOTE: this script does not need to be reversed in the down method since no data is being permanently moved
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        next if group.annual_budget.nil? || group.annual_budget == 0
        annual_budget = AnnualBudget.create(amount: group.annual_budget,
                                            closed: false,
                                            approved_budget: group.approved_budget,
                                            available_budget: group.available_budget,
                                            expenses: group.spent_budget,
                                            leftover_money: group.leftover_money,
                                            group_id: group.id,
                                            enterprise_id: group.enterprise_id)

        annual_budget.budgets << group.budgets
        group.initiatives.update_all(annual_budget_id: annual_budget.id)
        annual_budget.initiative_expenses << InitiativeExpense.where(initiative_id: group.initiative_ids)
      end
    end
  end

  def down
    say 'drop annual_budgets table...'

    remove_column :initiatives, :annual_budget_id, :integer
    remove_column :budgets, :annual_budget_id, :integer
    remove_column :initiative_expenses, :annual_budget_id, :integer

    drop_table :annual_budgets
  end
end
