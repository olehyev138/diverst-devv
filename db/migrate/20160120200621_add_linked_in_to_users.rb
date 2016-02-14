class AddLinkedInToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :linkedin_profile_url
    end
  end
end
