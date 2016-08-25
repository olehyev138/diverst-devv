class ChangeBiasAnonDefault < ActiveRecord::Migration
  def up
    change_column :biases, :anonymous, :boolean, :default => true
  end

  def down
    change_column :biases, :anonymous, :boolean, :default => false
  end
end