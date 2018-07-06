class AddPrivacyStatementToCustomText < ActiveRecord::Migration
  def change
  	add_column :custom_texts, :privacy_statement, :text
  end
end
