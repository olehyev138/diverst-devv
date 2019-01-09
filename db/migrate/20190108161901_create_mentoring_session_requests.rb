class CreateMentoringSessionRequests < ActiveRecord::Migration
  def change
    create_table :mentoring_session_requests do |t|
      t.references :mentoring_session, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.string :status, :null => false, :default => "pending"

      t.timestamps null: false
    end
  end
end
