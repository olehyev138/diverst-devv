class CreateIdeaCategories < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless table_exists? :idea_categories
      create_table :idea_categories do |t|
        t.string :name
        t.references :enterprise, index: true, foreign_key: true
        t.timestamps null: false
      end
    end
  end
end
