# Module to include Models which uses FieldData, containing needed functions and callbacks
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
      <<~SQL.gsub(/\s+/, ' ').strip
        #{get_old_sums}
        #{yield}
        #{set_new_sums}
      SQL
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
      sql = "SET @spent = (#{BudgetUser.select("COALESCE(`spent`, 0) as spent").left_joins(:budget_user_sums).where('`id` = OLD.`id`').to_sql}); "
      sql += "SET @count = (#{BudgetUser.select("count(id)").left_joins(:budget_user_sums).to_sql}); "
      sql += "SET @sum = (#{BudgetUser.select("sum(id)").left_joins(:budget_user_sums).to_sql}); "
      # UNCLOSED
      sql += 'IF COALESCE(OLD.`finished_expenses`, FALSE) AND NOT COALESCE(NEW.`finished_expenses`, FALSE) THEN '
      sql += 'SET @new_reserved = @old_reserved + OLD.`estimated` - @spent; '
      sql += 'SET @new_finalized_expenditures = @old_finalized_expenditures - @spent; ' if relevant_columns.include?('finalized_expenditures')
      # CLOSED
      sql += 'ELSEIF NOT COALESCE(OLD.`finished_expenses`, FALSE) AND COALESCE(NEW.`finished_expenses`, FALSE) THEN '
      sql += 'INSERT INTO `prints` VALUES(OLD.`id`); '
      sql += 'INSERT INTO `prints` VALUES(@old_reserved); '
      sql += 'INSERT INTO `prints` VALUES(OLD.`estimated`); '
      sql += 'INSERT INTO `prints` VALUES(@count); '
      sql += 'INSERT INTO `prints` VALUES(@sum); '
      sql += 'INSERT INTO `prints` VALUES(@spent); '
      sql += 'INSERT INTO `prints` VALUES(@old_finalized_expenditures); '
      sql += 'INSERT INTO `prints` VALUES("================================"); '
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
