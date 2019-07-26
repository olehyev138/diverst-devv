class TotalPageVisitation < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE OR REPLACE VIEW total_page_visitations AS
            SELECT 
              page_visitation_data.page AS page,
              SUM(page_visitation_data.times_visited) AS times_visited 
            FROM page_visitation_data 
            GROUP BY page_visitation_data.page
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP VIEW IF EXISTS total_page_visitations;
        SQL
      end
    end
  end
end
