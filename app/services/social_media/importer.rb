class SocialMedia::Importer
  def self.url_to_embed(url)
    return nil unless self.valid_url? url

<<-eos
 <div class="fb-post" data-href="https://www.facebook.com/LGBTQ/photos/a.559035344122874.147187.545385972154478/1885612558131806/?type=3&amp;theater" data-width="500" data-show-text="true"><blockquote cite="https://www.facebook.com/LGBTQ/posts/1885612558131806:0" class="fb-xfbml-parse-ignore"><p>Celebrating Pride? Now you can add a colorful background to your text posts! To access these limited-edition...</p>Posted by <a href="https://www.facebook.com/LGBTQ/">LGBTQ&#064;Facebook</a> on&nbsp;<a href="https://www.facebook.com/LGBTQ/posts/1885612558131806:0">Friday, June 16, 2017</a></blockquote></div>
eos
  end

  def self.valid_url?(url)
    true
  end
end
