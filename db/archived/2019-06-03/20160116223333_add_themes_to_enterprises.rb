class AddThemesToEnterprises < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.belongs_to :theme
    end
  end
end
