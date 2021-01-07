# Module for the purposes of creating triggers to create psudo materialized tables

# To elaborate, I'm going to give a broad example of how this works using the trigger of the insertion of an initiative expense
#
# First a brief overview of the methos used by all triggers/matrialized tables
#
# These methods are only for the purpose of create a string representing a sql trigger, and don't by themselves do anything
# `relevant_columns`: return the list of columns save for the id. These will be used to indicate which column values to be loaded
# `get_old_sums`: for each relevant_column, takes the old data and stores them into variables @old_{column_name}
# `set_new_sums`: for each relevant_column, take the values @new_{column_name} and replaces them into the materialized table
# `set_rest`: for each relevant_column *not* given as an argument, set @new_{column_name} = @old_{column_name}
# `trigger_wrapper`: wraps the passed block's sql around the `get_old` and `set_new` string
#
# Next are trigger specific methods: These are the main logic for a specific trigger
# These usually comes in two parts, the primary logic (which sets all the @new values), and the full read and write sql
# For expense insertion the logic method is `expense_adder`:
#     which is used to increase a rows `spent` column by the amount of the inserted expense, as well as keeping every other column the same
# The full read write method `expense_inserted` simply calls trigger_wrapper on the above method
#
# Once you have the methods, you go to the Model which will have the trigger and procede to do two things
# 1) define a `self.get_foreign_keys(old_or_new = 'NEW')` method.
#     This method should retirive and set all matial tables foriegn keys that the trigger might use and set them as sql variables.
#
# 2) Define the trigger itself
#    trigger.after(:insert) do
#      <<~SQL.gsub(/\s+/, ' ').strip
#      #{get_foreign_keys}
#      #{BudgetUserSums.expense_inserted}
#      #{BudgetItemSums.expense_inserted}
#      #{BudgetSums.expense_inserted}
#      #{AnnualBudgetSums.expense_inserted}
#      SQL
#    end
#
# This will be the full sql that will run on each insert.
# You will see that when an expense is inserted, we want to update multiple sums. Make sure for each one you retireve the needed key with `get_foreign_keys`
#
# The trigger will start by getting the needed keys, then run the sql defined by `expense_inserted` for BudgetUserSum, which was read all the current data into @old_{data}
# Set @new_spent = @old_spent + NEW.spent, and set all the other @new_{data} to be the same as the old. Then lastly replace that data back into the sum table.
# Repeate for each sum table.
#
# Make sure that whenever you change the triggers, run the command
# `rake db:generate_trigger_migration`
# to create a migration that updates the triggers

module MaterializedTable
  extend ActiveSupport::Concern

  class_methods do
    def relevant_columns
      @relevant_columns ||= column_names.reject { |a| a.include? 'id' }
    end

    def get_old_sums
      <<~SQL.gsub(/\s+/, ' ').strip
        #{relevant_columns.map { |col| "SET @old_#{col} = 0;" }.join("\n")}
        #{
            select(*(relevant_columns.map { |col| "IFNULL(#{col}, 0)" }))
                .where("`#{primary_key}` = @#{primary_key}")
                .to_sql
          }
        INTO #{relevant_columns.map { |col| "@old_#{col}" }.join(", ")};
      SQL
    end

    def set_new_sums
      <<~SQL.gsub(/\s+/, ' ').strip
        REPLACE INTO #{table_name}
        VALUES(@#{primary_key}, #{relevant_columns.map { |col| "IFNULL(@new_#{col}, 0)" }.join(', ')});
      SQL
    end

    def set_rest(*used_values)
      (relevant_columns - used_values).map do |col|
        "SET @new_#{col} = @old_#{col};"
      end.join("\n")
    end

    def trigger_wrapper
      if sums_tables_exist?
        <<~SQL.gsub(/\s+/, ' ').strip
          #{get_old_sums}
          #{yield}
          #{set_new_sums}
        SQL
      end
    end

    def expense_adder
      sql = 'SET @new_spent = @old_spent + NEW.amount; '
      sql + set_rest('spent')
    end

    def expense_remover
      sql = 'SET @new_spent = @old_spent - OLD.amount; '
      sql + set_rest('spent')
    end

    def expense_replacer
      sql = 'SET @new_spent = @old_spent + NEW.amount - OLD.amount; '
      sql + set_rest('spent')
    end

    def estimate_adder
      sql = 'SET @new_reserved = @old_reserved + NEW.estimated; '
      sql += 'SET @new_user_estimates = @old_user_estimates + NEW.estimated; ' if relevant_columns.include? 'user_estimates'
      sql + set_rest('reserved', 'user_estimates')
    end

    def estimate_remover
      sql = "SET @temp = (#{
        BudgetUser
            .select("IF(`finished_expenses` = TRUE, COALESCE(`spent`, 0), COALESCE(`estimated`, 0)) as reserved")
            .left_joins(:budget_user_sums).where('`id` = OLD.`id`')
            .to_sql
      }); "
      sql += 'SET @new_reserved = @old_reserved - @temp; '
      sql += 'SET @new_user_estimates = @old_user_estimates - OLD.estimated; ' if relevant_columns.include? 'user_estimates'
      sql + set_rest('reserved', 'user_estimates')
    end

    def estimate_replacer
      sql = 'SET @new_reserved = @old_reserved + NEW.estimated - OLD.estimated; '
      sql += 'SET @new_user_estimates = @old_user_estimates + NEW.estimated - OLD.estimated; ' if relevant_columns.include? 'user_estimates'
      sql + set_rest('reserved', 'user_estimates')
    end

    def estimate_finalized
      sql = "SET @spent = (#{BudgetUserSums.select(:spent).where('`budget_user_id` = OLD.`id`').to_sql}); "
      # UNCLOSED
      sql += 'IF COALESCE(OLD.`finished_expenses`, FALSE) AND NOT COALESCE(NEW.`finished_expenses`, FALSE) THEN '
      sql += 'SET @new_reserved = @old_reserved + OLD.`estimated` - @spent; '
      sql += 'SET @new_finalized_expenditures = @old_finalized_expenditures - @spent; ' if relevant_columns.include?('finalized_expenditures')
      # CLOSED
      sql += 'ELSEIF NOT COALESCE(OLD.`finished_expenses`, FALSE) AND COALESCE(NEW.`finished_expenses`, FALSE) THEN '
      sql += 'SET @new_reserved = @old_reserved - OLD.`estimated` + @spent; '
      sql += 'SET @new_finalized_expenditures = @old_finalized_expenditures + @spent; ' if relevant_columns.include?('finalized_expenditures')
      sql += 'END IF; '
      sql + set_rest('reserved', 'finalized_expenditures')
    end

    def request_adder
      sql = 'SET @new_requested_amount = @old_requested_amount + NEW.`estimated_amount`; '
      sql + set_rest('requested_amount')
    end

    def request_remover
      sql = 'SET @new_requested_amount = @old_requested_amount - OLD.`estimated_amount`; '
      sql + set_rest('requested_amount')
    end

    def budget_approver
      sql = "SET @requested = (#{
      Budget
          .select("COALESCE(`requested_amount`, 0) as requested_amount")
          .left_joins(:budget_sums)
          .where('`id` = NEW.`id`').to_sql
    }); "
      # UN APPROVED
      sql += 'IF COALESCE(OLD.`is_approved`, FALSE) AND NOT COALESCE(NEW.`is_approved`, FALSE) THEN '
      sql += 'SET @new_approved = @old_approved - @requested; '
      # APPROVED
      sql += 'ELSEIF NOT COALESCE(OLD.`is_approved`, FALSE) AND COALESCE(NEW.`is_approved`, FALSE) THEN '
      sql += 'SET @new_approved = @old_approved + @requested; '
      sql += 'END IF; '
      sql + set_rest('approved', 'finalized_expenditures')
    end

    def sums_tables_exist?
      AnnualBudgetSums.table_exists? && BudgetSums.table_exists? && BudgetItemSums.table_exists? && BudgetUserSums.table_exists?
    end

    def expense_inserted
      trigger_wrapper(&method(:expense_adder))
    end

    def expense_deleted
      trigger_wrapper(&method(:expense_remover))
    end

    def expense_updated
      trigger_wrapper(&method(:expense_replacer))
    end

    def budget_user_inserted
      trigger_wrapper(&method(:estimate_adder))
    end

    def budget_user_deleted
      trigger_wrapper(&method(:estimate_remover))
    end

    def budget_user_estimate_updated
      trigger_wrapper(&method(:estimate_replacer))
    end

    def budget_user_finalized
      trigger_wrapper(&method(:estimate_finalized))
    end

    def budget_inserted
      trigger_wrapper(&method(:request_adder))
    end

    def budget_deleted
      trigger_wrapper(&method(:request_remover))
    end

    def budget_approved
      trigger_wrapper(&method(:budget_approver))
    end
  end
end
