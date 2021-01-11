class AddTogglesToEnterprise < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :enterprises, :invite_member_enabled
      add_column :enterprises, :invite_member_enabled, :boolean, default: false
    end

    unless column_exists? :enterprises, :suggest_hire_enabled
      add_column :enterprises, :suggest_hire_enabled, :boolean, default: false
    end
  end
end
