class AddPrivacyStatementToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.text :privacy_statement
    end
  end
end
