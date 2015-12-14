class AddYammerTokenToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.string :yammer_token
    end
  end
end
