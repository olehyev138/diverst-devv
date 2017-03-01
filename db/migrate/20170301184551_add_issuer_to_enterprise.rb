class AddIssuerToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.string :sp_entity_id, after: :name
    end
  end
end
