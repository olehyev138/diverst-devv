class CreateMentoringSessionComments < ActiveRecord::Migration
  def change
    create_table :mentoring_session_comments do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.references :mentoring_session, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
