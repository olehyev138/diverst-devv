# Module to include Models which uses FieldData, containing needed functions and callbacks
module MaterializedTable
  extend ActiveSupport::Concern

  class_methods do
    def relevant_columns
      relevant_columns ||= column_names.reject{|a| a.include? 'id'}
    end

    def get_old_sums
      <<~SQL.gsub(/\s+/, ' ').strip
        #{relevant_columns.map {|col| "SET @old_#{col} = 0;" }.join("\n")}
        #{
            select(*(relevant_columns.map {|col| "IFNULL(#{col}, 0)"}))
                .where("`#{primary_key}` = @#{primary_key}")
                .to_sql
        }
        INTO #{relevant_columns.map {|col| "@old_#{col}" }.join(", ")};
      SQL
    end

    def set_new_sums
      <<~SQL.gsub(/\s+/, ' ').strip
        REPLACE INTO #{table_name}
        VALUES(@#{primary_key}, #{relevant_columns.map {|col| "IFNULL(@new_#{col}, 0)"}.join(', ')});
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
      sql + set_rest('spent', 'unspent', 'leftover')
    end

    def expense_remover
      sql = 'SET @new_spent = @old_spent - OLD.amount; '
      sql + set_rest('spent', 'unspent', 'leftover')
    end

    def expense_replacer
      sql = 'SET @new_spent = @old_spent + NEW.amount - OLD.amount; '
      sql + set_rest('spent', 'unspent', 'leftover')
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
      trigger_wrapper(&method(:expense_adder))
    end

    def budget_user_deleted
      trigger_wrapper(&method(:expense_remover))
    end

    def budget_user_estimate_updated
      trigger_wrapper(&method(:expense_replacer))
    end

    def budget_user_finalized
      trigger_wrapper(&method(:expense_replacer))
    end
  end
end
