class CreateSocialLinkSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :social_link_segments do |t|
      t.references    :social_link
      t.references    :segment
      t.timestamps null: false
    end
  end
end
