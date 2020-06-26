class CreateUserPollTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_poll_tokens do |t|
      t.belongs_to :user
      t.belongs_to :poll
      t.string :token
      t.boolean :submitted, default: false
      t.boolean :cancelled, default: false

      t.timestamps
    end
  end
end
