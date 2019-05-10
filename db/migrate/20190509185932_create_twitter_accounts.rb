class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.belongs_to :group
      t.string :name
      t.string :account

      t.timestamps null: false
    end
  end
end
