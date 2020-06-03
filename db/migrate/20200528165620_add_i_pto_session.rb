class AddIPtoSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :sign_in_ip, :string
  end
end
