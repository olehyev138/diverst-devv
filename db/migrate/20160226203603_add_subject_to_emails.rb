class AddSubjectToEmails < ActiveRecord::Migration
  def change
    change_table :emails do |t|
      t.string :subject
    end
  end
end
