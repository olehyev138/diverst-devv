class AddJobTitleToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :job_title
    end
  end
end
