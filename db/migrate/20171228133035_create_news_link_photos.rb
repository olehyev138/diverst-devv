class CreateNewsLinkPhotos < ActiveRecord::Migration
  def change
    # create photos
    if !ActiveRecord::Base.connection.table_exists? 'news_link_photos'
      create_table :news_link_photos do |t|
        t.attachment :file
        t.belongs_to :news_link
        t.timestamps null: false
      end
    end

    # migrate existing newsLink pictures to news_link_photos
    NewsLink.find_each do |news_link|
      if news_link.picture.exists?
        photo = news_link.news_link_photos.new
        photo.file = news_link.picture
        photo.save!
      end
    end
  end
end
