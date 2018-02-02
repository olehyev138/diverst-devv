class UpdateIndexes < ActiveRecord::Migration
    def change
        change_column :users, :email,                :string, :limit => 191
        change_column :users, :invitation_token,     :string, :limit => 191
        change_column :users, :reset_password_token, :string, :limit => 191
        change_column :users, :unlock_token,         :string, :limit => 191
    end
end
