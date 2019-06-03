class AddSubjectToEmails < ActiveRecord::Migration[5.1]
  def change
    change_table :emails do |t|
      t.string :subject
    end
  end
end
