class CreateSuggestedHires < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless table_exists? :suggested_hires
      create_table :suggested_hires do |t|
        t.references :user, index: true, foreign_key: true
        t.references :group, index: true, foreign_key: true

        t.timestamps null: false
      end
    end
  end
end
