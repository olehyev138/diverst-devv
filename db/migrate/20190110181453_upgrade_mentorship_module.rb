class UpgradeMentorshipModule < ActiveRecord::Migration[5.1]
  def change
    create_table :mentoring_session_comments do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.references :mentoring_session, index: true, foreign_key: true

      t.timestamps null: false
    end

    remove_column :mentorship_sessions, :attending, :boolean
    add_column :mentorship_sessions, :status, :string, :null => false, :default => "pending"
  end
end
