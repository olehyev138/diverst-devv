class AddPrivacyStatementToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.text :privacy_statement
    end
  end
end
