class AddNonsooAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :employee_id, :string
    add_column :users, :dob, :string
  end
end
