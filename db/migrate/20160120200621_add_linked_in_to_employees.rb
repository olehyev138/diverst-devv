class AddLinkedInToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :linkedin_profile_url
    end
  end
end
