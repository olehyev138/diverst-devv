# Module to include Models which uses FieldData, containing needed functions and callbacks
module MaterializedTable
  extend ActiveSupport::Concern

  class_methods do
    def relevant_columns
      relevant_columns ||= column_names.reject{|a| a.include? 'id'}
    end

    def get_old_sums(old_or_new = 'NEW')
      <<~SQL.gsub(/\s+/, ' ').strip
      #{relevant_columns.map {|col| "SET @old_#{col} = 0;" }.join("\n")}
      #{
          select(*(relevant_columns.map {|col| "IFNULL(#{col}, 0)"}))
              .where("`#{primary_key}` = #{old_or_new}.`#{primary_key}`")
              .to_sql
      }
      INTO #{relevant_columns.map {|col| "@old_#{col}" }.join(", ")};
      SQL
    end

    def set_new_sums(old_or_new = 'NEW')
      <<~SQL.gsub(/\s+/, ' ').strip
      REPLACE INTO #{table_name}
      VALUES(#{old_or_new}.#{primary_key}, #{relevant_columns.map {|col| "IFNULL(@new_#{col}, 0)"}.join(', ')});
      SQL
    end
  end
end
