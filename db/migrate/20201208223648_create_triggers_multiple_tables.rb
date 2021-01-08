# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersMultipleTables < ActiveRecord::Migration[5.2]
  def up
    create_trigger("budgets_after_update_of_is_approved_row_tr", :generated => true, :compatibility => 1).
        on("budgets").
        after(:update).
        of(:is_approved) do
      "SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budgets`.`id`, `budgets`.`annual_budget_id` FROM `budgets` WHERE (`budgets`.`id` = NEW.`id`) INTO @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @requested = (SELECT COALESCE(`requested_amount`, 0) as requested_amount FROM `budgets` LEFT OUTER JOIN `budgets_sums` ON `budgets_sums`.`budget_id` = `budgets`.`id` WHERE (`id` = NEW.`id`)); IF COALESCE(OLD.`is_approved`, FALSE) AND NOT COALESCE(NEW.`is_approved`, FALSE) THEN SET @new_approved = @old_approved - @requested; ELSEIF NOT COALESCE(OLD.`is_approved`, FALSE) AND COALESCE(NEW.`is_approved`, FALSE) THEN SET @new_approved = @old_approved + @requested; END IF; SET @new_spent = @old_spent; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_requested_amount = @old_requested_amount; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_items_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("budget_items").
        after(:insert) do
      "SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budgets`.`id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` INNER JOIN `annual_budgets` ON `annual_budgets`.`id` = `budgets`.`annual_budget_id` WHERE (`budget_items`.`id` = NEW.`id`) INTO @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_requested_amount = @old_requested_amount + NEW.`estimated_amount`; SET @new_spent = @old_spent; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_requested_amount = @old_requested_amount + NEW.`estimated_amount`; SET @new_spent = @old_spent; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_items_before_delete_row_tr", :generated => true, :compatibility => 1).
        on("budget_items").
        before(:delete) do
      "SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budgets`.`id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` INNER JOIN `annual_budgets` ON `annual_budgets`.`id` = `budgets`.`annual_budget_id` WHERE (`budget_items`.`id` = OLD.`id`) INTO @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_requested_amount = @old_requested_amount - OLD.`estimated_amount`; SET @new_spent = @old_spent; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_requested_amount = @old_requested_amount - OLD.`estimated_amount`; SET @new_spent = @old_spent; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_users_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("budget_users").
        after(:insert) do
      "SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_items`.`id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_items`.`id` = NEW.`budget_item_id`) INTO @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @new_reserved = @old_reserved + NEW.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_reserved = @old_reserved + NEW.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_reserved = @old_reserved + NEW.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_users_before_delete_row_tr", :generated => true, :compatibility => 1).
        on("budget_users").
        before(:delete) do
      "SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_items`.`id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_items`.`id` = OLD.`budget_item_id`) INTO @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @temp = (SELECT IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); SET @new_reserved = @old_reserved - @temp; SET @new_user_estimates = @old_user_estimates - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @temp = (SELECT IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); SET @new_reserved = @old_reserved - @temp; SET @new_user_estimates = @old_user_estimates - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @temp = (SELECT IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); SET @new_reserved = @old_reserved - @temp; SET @new_user_estimates = @old_user_estimates - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_users_after_update_of_estimated_row_tr", :generated => true, :compatibility => 1).
        on("budget_users").
        after(:update).
        of(:estimated) do
      "SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_items`.`id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_items`.`id` = NEW.`budget_item_id`) INTO @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @new_reserved = @old_reserved + NEW.estimated - OLD.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_reserved = @old_reserved + NEW.estimated - OLD.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_reserved = @old_reserved + NEW.estimated - OLD.estimated; SET @new_user_estimates = @old_user_estimates + NEW.estimated - OLD.estimated; SET @new_spent = @old_spent; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("budget_users_after_update_of_finished_expenses_row_tr", :generated => true, :compatibility => 1).
        on("budget_users").
        after(:update).
        of(:finished_expenses) do
      "SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_items`.`id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_items` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_items`.`id` = NEW.`budget_item_id`) INTO @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @spent = (SELECT COALESCE(`spent`, 0) as spent FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); IF COALESCE(OLD.`finished_expenses`, FALSE) AND NOT COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved + OLD.`estimated` - @spent; SET @new_finalized_expenditures = @old_finalized_expenditures - @spent; ELSEIF NOT COALESCE(OLD.`finished_expenses`, FALSE) AND COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved - OLD.`estimated` + @spent; SET @new_finalized_expenditures = @old_finalized_expenditures + @spent; END IF; SET @new_spent = @old_spent; SET @new_user_estimates = @old_user_estimates; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @spent = (SELECT COALESCE(`spent`, 0) as spent FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); IF COALESCE(OLD.`finished_expenses`, FALSE) AND NOT COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved + OLD.`estimated` - @spent; SET @new_finalized_expenditures = @old_finalized_expenditures - @spent; ELSEIF NOT COALESCE(OLD.`finished_expenses`, FALSE) AND COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved - OLD.`estimated` + @spent; SET @new_finalized_expenditures = @old_finalized_expenditures + @spent; END IF; SET @new_spent = @old_spent; SET @new_user_estimates = @old_user_estimates; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @spent = (SELECT COALESCE(`spent`, 0) as spent FROM `budget_users` LEFT OUTER JOIN `budget_users_sums` ON `budget_users_sums`.`budget_user_id` = `budget_users`.`id` WHERE (`id` = OLD.`id`)); IF COALESCE(OLD.`finished_expenses`, FALSE) AND NOT COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved + OLD.`estimated` - @spent; SET @new_finalized_expenditures = @old_finalized_expenditures - @spent; ELSEIF NOT COALESCE(OLD.`finished_expenses`, FALSE) AND COALESCE(NEW.`finished_expenses`, FALSE) THEN SET @new_reserved = @old_reserved - OLD.`estimated` + @spent; SET @new_finalized_expenditures = @old_finalized_expenditures + @spent; END IF; SET @new_spent = @old_spent; SET @new_user_estimates = @old_user_estimates; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("initiative_expenses_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:insert) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = NEW.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent + NEW.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_spent = @old_spent + NEW.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("initiative_expenses_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:delete) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = OLD.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent - OLD.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_spent = @old_spent - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end

    create_trigger("initiative_expenses_after_update_of_amount_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:update).
        of(:amount) do
      "SET @budget_user_id = -1; SET @budget_item_id = -1; SET @budget_id = -1; SET @annual_budget_id = -1; SELECT `budget_users`.`id`, `budget_users`.`budget_item_id`, `budget_items`.`budget_id`, `budgets`.`annual_budget_id` FROM `budget_users` INNER JOIN `budget_items` ON `budget_items`.`id` = `budget_users`.`budget_item_id` INNER JOIN `budgets` ON `budgets`.`id` = `budget_items`.`budget_id` WHERE (`budget_users`.`id` = NEW.`budget_user_id`) INTO @budget_user_id, @budget_item_id, @budget_id, @annual_budget_id; SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM `budget_users_sums` WHERE (`budget_user_id` = @budget_user_id) INTO @old_spent; SET @new_spent = @old_spent + NEW.amount - OLD.amount; REPLACE INTO budget_users_sums VALUES(@budget_user_id, IFNULL(@new_spent, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0) FROM `budget_items_sums` WHERE (`budget_item_id` = @budget_item_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; REPLACE INTO budget_items_sums VALUES(@budget_item_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0) FROM `budgets_sums` WHERE (`budget_id` = @budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; REPLACE INTO budgets_sums VALUES(@budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0)); SET @old_spent = 0; SET @old_reserved = 0; SET @old_user_estimates = 0; SET @old_finalized_expenditures = 0; SET @old_requested_amount = 0; SET @old_approved = 0; SELECT IFNULL(spent, 0), IFNULL(reserved, 0), IFNULL(user_estimates, 0), IFNULL(finalized_expenditures, 0), IFNULL(requested_amount, 0), IFNULL(approved, 0) FROM `annual_budgets_sums` WHERE (`annual_budget_id` = @annual_budget_id) INTO @old_spent, @old_reserved, @old_user_estimates, @old_finalized_expenditures, @old_requested_amount, @old_approved; SET @new_spent = @old_spent + NEW.amount - OLD.amount; SET @new_reserved = @old_reserved; SET @new_user_estimates = @old_user_estimates; SET @new_finalized_expenditures = @old_finalized_expenditures; SET @new_requested_amount = @old_requested_amount; SET @new_approved = @old_approved; REPLACE INTO annual_budgets_sums VALUES(@annual_budget_id, IFNULL(@new_spent, 0), IFNULL(@new_reserved, 0), IFNULL(@new_user_estimates, 0), IFNULL(@new_finalized_expenditures, 0), IFNULL(@new_requested_amount, 0), IFNULL(@new_approved, 0));"
    end
  end

  def down
    drop_trigger("budgets_after_update_of_is_approved_row_tr", "budgets", :generated => true)

    drop_trigger("budget_items_after_insert_row_tr", "budget_items", :generated => true)

    drop_trigger("budget_items_before_delete_row_tr", "budget_items", :generated => true)

    drop_trigger("budget_users_after_insert_row_tr", "budget_users", :generated => true)

    drop_trigger("budget_users_before_delete_row_tr", "budget_users", :generated => true)

    drop_trigger("budget_users_after_update_of_estimated_row_tr", "budget_users", :generated => true)

    drop_trigger("budget_users_after_update_of_finished_expenses_row_tr", "budget_users", :generated => true)

    drop_trigger("initiative_expenses_after_insert_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_delete_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_update_of_amount_row_tr", "initiative_expenses", :generated => true)
  end
end