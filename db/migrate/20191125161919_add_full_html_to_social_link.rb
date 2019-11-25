class AddFullHtmlToSocialLink < ActiveRecord::Migration
  def up
    add_column :social_network_posts, :small_embed_code, :text

    SocialLink.find_each do |sl|
      unless sl.embed_code && sl.small_embed_code
        sl.re_populate_both_embed_code
        sl.save!
      end
    end
  end

  def down
    SocialLink.find_each do |sl|
      if sl.embed_code && sl.small_embed_code
        sl.embed_code = sl.small_embed_code
        sl.save!
      end
    end

    remove_column :social_network_posts, :small_embed_code
  end
end
