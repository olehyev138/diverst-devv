class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.belongs_to :group
      t.string :name, null: false
      t.string :account, null: false

      t.timestamps null: false
    end
  end
end
