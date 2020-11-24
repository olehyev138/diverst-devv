# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersInitiativeExpensesInsertOrInitiativeExpensesDeleteOrInitiativeExpensesUpdate < ActiveRecord::Migration[5.2]
  def up
    create_trigger("initiative_expenses_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:insert) do
      "SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM budget_users_sums WHERE budget_user_id = NEW.budget_user_id INTO @old_spent; SET @new_spent = @old_spent + NEW.amount; REPLACE INTO budget_users_sums VALUES(NEW.budget_user_id, IFNULL(@new_spent, 0));"
    end

    create_trigger("initiative_expenses_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:delete) do
      "SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM budget_users_sums WHERE budget_user_id = OLD.budget_user_id INTO @old_spent; SET @new_spent = @old_spent - OLD.amount; REPLACE INTO budget_users_sums VALUES(OLD.budget_user_id, IFNULL(@new_spent, 0));"
    end

    create_trigger("initiative_expenses_after_update_of_amount_row_tr", :generated => true, :compatibility => 1).
        on("initiative_expenses").
        after(:update).
        of(:amount) do
      "SET @old_spent = 0; SELECT IFNULL(spent, 0) FROM budget_users_sums WHERE budget_user_id = NEW.budget_user_id INTO @old_spent; SET @new_spent = @old_spent + NEW.amount - OLD.amount; REPLACE INTO budget_users_sums VALUES(NEW.budget_user_id, IFNULL(@new_spent, 0));"
    end
  end

  def down
    drop_trigger("initiative_expenses_after_insert_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_delete_row_tr", "initiative_expenses", :generated => true)

    drop_trigger("initiative_expenses_after_update_of_amount_row_tr", "initiative_expenses", :generated => true)
  end
end
