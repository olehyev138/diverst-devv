# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersInitiativeExpensesInsertOrInitiativeExpensesDeleteOrInitiativeExpensesUpdate < ActiveRecord::Migration[5.2]
  def up
    create_trigger("initiative_expenses_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:insert) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = NEW.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent + NEW.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_finalized_expenditures; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available, @old_approved; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("initiative_expenses_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:delete) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = OLD.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent - OLD.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_finalized_expenditures; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available, @old_approved; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("initiative_expenses_after_update_of_amount_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:update).
        of(:amount) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = NEW.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent + NEW.amount - OLD.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_finalized_expenditures; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_requested_amount = 0; SET @old_available = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(requested_amount, 0), IFNULL(available, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_requested_amount, @old_available, @old_approved; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_requested_amount = @old_requested_amount; SET @new_available = @old_available; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_available, 0), IFNULL(@new_approved, 0));"
    end
  end

  def down
    drop_trigger("initiative_expenses_after_insert_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_delete_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_update_of_amount_row_tr", "initiative_expenses", :generated => true)
  end
end
