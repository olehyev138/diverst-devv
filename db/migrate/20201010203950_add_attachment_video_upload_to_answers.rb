class AddAttachmentVideoUploadToAnswers < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #  - legacy migration uses paperclip `add_attachment` helper method, which creates the 4 following columns,
    #    have to check for existence for legacy db migrations
    #
    unless column_exists? :answers, :video_upload_file_name
      add_column :answers, :video_upload_file_name, :string
    end

    unless column_exists? :answers, :video_upload_content_type
      add_column :answers, :video_upload_content_type, :string
    end

    unless column_exists? :answers, :video_upload_file_size
      add_column :answers, :video_upload_file_size, :integer
    end

    unless column_exists? :answers, :video_upload_updated_at
      add_column :answers, :video_upload_updated_at, :datetime
    end
  end
end
