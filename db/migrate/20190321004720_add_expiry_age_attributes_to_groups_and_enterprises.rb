class AddExpiryAgeAttributesToGroupsAndEnterprises < ActiveRecord::Migration
  def change
    add_column :groups, :expiry_age_for_news, :integer, default: 0
    add_column :groups, :expiry_age_for_resources, :integer, default: 0
    add_column :groups, :expiry_age_for_events, :integer, default: 0
    add_column :enterprises, :expiry_age_for_resources, :integer, default: 0
    add_column :groups, :unit_of_expiry_age, :string
    add_column :enterprises, :unit_of_expiry_age, :string
  end
end
