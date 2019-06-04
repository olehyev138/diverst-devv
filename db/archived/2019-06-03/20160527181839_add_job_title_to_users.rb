class AddJobTitleToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :job_title
    end
  end
end
