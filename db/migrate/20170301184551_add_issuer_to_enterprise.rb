class AddIssuerToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.string :sp_entity_id, after: :name
    end
  end
end
