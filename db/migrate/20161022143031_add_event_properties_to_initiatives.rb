class AddEventPropertiesToInitiatives < ActiveRecord::Migration
  def change
    change_table :initiatives do |t|
      t.text    :description
      t.integer :max_attendees

      t.string   :picture_file_name
      t.string   :picture_content_type
      t.integer  :picture_file_size
      t.datetime :picture_updated_at
    end

    create_table :initiative_invitees do |t|
      t.integer :initiative_id
      t.integer :user_id
    end

    create_table :initiative_comments do |t|
      t.integer :initiative_id
      t.integer :user_id
      t.text    :content
    end

    create_table :initiative_segments do |t|
      t.integer :initiative_id
      t.integer :segment_id
    end
  end
end
