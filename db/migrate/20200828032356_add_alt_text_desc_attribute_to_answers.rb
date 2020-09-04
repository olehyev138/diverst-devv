class AddAltTextDescAttributeToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :video_upload_alt_text_desc, :string
  end
end
