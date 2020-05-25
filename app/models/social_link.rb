class SocialLink < BaseClass
  include PublicActivity::Common

  self.table_name = 'social_network_posts'

  has_one :news_feed_link

  has_many :social_link_segments, dependent: :destroy
  has_many :segments, through: :social_link_segments, before_remove: :remove_segment_association
  has_many :user_reward_actions, dependent: :destroy

  belongs_to :author, class_name: 'User', required: true, counter_cache: true
  belongs_to :group

  accepts_nested_attributes_for :news_feed_link, allow_destroy: true

  validate :correct_url?

  validates :author_id, presence: true

  before_create :build_default_link, :add_trailing_slash
  after_create :hack_temp_solution

  after_destroy :remove_news_feed_link

  scope :of_segments, ->(segment_ids) {
    gm_condtions = ['social_link_segments.segment_id IS NULL']
    gm_condtions << "social_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN social_link_segments ON social_link_segments.social_link_id = social_network_posts.id')
      .where(gm_condtions.join(' OR '))
  }

  scope :unapproved, -> { joins(:news_feed_link).where(news_feed_links: { approved: false }) }

  def url_safe
    CGI.escape(url)
  end

  # call back to delete news link segment associations
  def remove_segment_association(segment)
    social_link_segment = self.social_link_segments.find_by(segment_id: segment.id)
    social_link_segment.news_feed_link_segment.destroy
  end

  def re_populate_embed_code(small: false)
    new_html = SocialMedia::Importer.url_to_embed(url, small: small)

    update_column(small ? :small_embed_code : :embed_code, new_html)
  rescue => e
    errors.add(:url, e.message)
  end

  def re_populate_both_embed_code
    re_populate_embed_code small: false
    re_populate_embed_code small: true
  end

  protected

  def correct_url?
    self.embed_code = SocialMedia::Importer.url_to_embed url
    self.small_embed_code = SocialMedia::Importer.url_to_embed(url, small: true)
  rescue => e
    errors.add(:url, e.message)
  end

  def add_trailing_slash
    self.url = File.join(self.url, '')
  end

  def hack_temp_solution
    if small_embed_code.include? '<a href=https://www.linkedin.com/signup/cold-join>Sign Up | LinkedIn</a>'
      sleep(1)
      save
    end
  end

  private

  def build_default_link
    return if news_feed_link.present?

    create_news_feed_link(news_feed_id: group.news_feed.id)
  end

  def remove_news_feed_link
    news_feed_link.destroy if news_feed_link.present?
  end
end
