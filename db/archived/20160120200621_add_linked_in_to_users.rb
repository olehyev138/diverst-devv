class AddLinkedInToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :linkedin_profile_url
    end
  end
end
