class AddPrivacyStatementToCustomText < ActiveRecord::Migration[5.1]
  def change
  	add_column :custom_texts, :privacy_statement, :text
  end
end
