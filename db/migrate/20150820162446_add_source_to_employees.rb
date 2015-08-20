class AddSourceToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :auth_source
    end
  end
end
