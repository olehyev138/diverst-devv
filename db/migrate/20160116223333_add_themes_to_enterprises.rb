class AddThemesToEnterprises < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.belongs_to :theme
    end
  end
end
