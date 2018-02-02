class ChangeEncodingForAllTables < ActiveRecord::Migration
    # https://gist.github.com/tjh/1711329
    def db
        ActiveRecord::Base.connection
    end

    def up
        execute "ALTER DATABASE `#{db.current_database}` CHARACTER SET utf8mb4;"
        db.tables.each do |table|
            execute "ALTER TABLE `#{table}` CHARACTER SET = utf8mb4;"
            
            next if table === "schema_migrations"
            
            db.columns(table).each do |column|
                case column.sql_type
                when "text"
                    execute "ALTER TABLE `#{table}` CHANGE `#{column.name}` `#{column.name}` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
                when /varchar\(([0-9]+)\)/i
                    # InnoDB has a maximum index length of 767 bytes, so for utf8 or utf8mb4
                    # columns, you can index a maximum of 255 or 191 characters, respectively.
                    # If you currently have utf8 columns with indexes longer than 191 characters,
                    # you will need to index a smaller number of characters.
                    indexed_column = db.indexes(table).any? { |index| index.columns.include?(column.name) }
                    sql_type = (indexed_column && $1.to_i > 191) ? "VARCHAR(191)" : column.sql_type.upcase
                    execute "ALTER TABLE `#{table}` CHANGE `#{column.name}` `#{column.name}` #{sql_type} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
                end
            end
        end
    end
end
