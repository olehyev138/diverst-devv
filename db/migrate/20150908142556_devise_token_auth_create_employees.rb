class DeviseTokenAuthCreateEmployees < ActiveRecord::Migration
  def change
    change_table(:employees) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Tokens
      t.text :tokens
    end
  end
end
