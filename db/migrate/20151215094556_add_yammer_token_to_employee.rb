class AddYammerTokenToEmployee < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :yammer_token
    end
  end
end
