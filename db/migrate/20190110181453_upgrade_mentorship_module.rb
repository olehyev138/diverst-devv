class UpgradeMentorshipModule < ActiveRecord::Migration[5.2]
  def change
    create_table(:mentoring_session_comments, id: :integer) do |t|
      t.text :content
      t.integer :user_id
      t.integer :mentoring_session_id
      t.timestamps null: false
    end

    MentoringSessionComment.connection.schema_cache.clear!
    MentoringSessionComment.reset_column_information

    add_foreign_key :mentoring_session_comments, :users
    add_foreign_key :mentoring_session_comments, :mentoring_sessions

    #t.references :user, index: true, foreign_key: true, type: :integer
    #t.references :mentoring_session, index: true, foreign_key: true, type: :integer

    remove_column :mentorship_sessions, :attending, :boolean
    add_column :mentorship_sessions, :status, :string, :null => false, :default => "pending"
  end
end
