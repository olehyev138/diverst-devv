class SocialLink < ApplicationRecord
  include PublicActivity::Common
  include SocialLink::Actions

  self.table_name = 'social_network_posts'

  has_one :news_feed_link

  has_many :social_link_segments, dependent: :destroy
  has_many :segments, through: :social_link_segments, before_remove: :remove_segment_association
  has_many :user_reward_actions, dependent: :destroy

  accepts_nested_attributes_for :news_feed_link, allow_destroy: true

  validate :correct_url?

  before_create :populate_embed_code, :build_default_link, :add_trailing_slash

  belongs_to :author, class_name: 'User'
  belongs_to :group

  validates :author_id, presence: true
  validates :author, presence: true
  after_destroy :remove_news_feed_link

  scope :of_segments, ->(segment_ids) {
    gm_condtions = ['social_link_segments.segment_id IS NULL']
    gm_condtions << "social_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN social_link_segments ON social_link_segments.social_link_id = social_network_posts.id')
      .where(gm_condtions.join(' OR '))
  }

  scope :unapproved, -> { joins(:news_feed_link).where(news_feed_links: { approved: false }) }

  def self.symbol
    :social_link
  end

  def url_safe
    CGI.escape(url)
  end

  # call back to delete news link segment associations
  def remove_segment_association(segment)
    social_link_segment = self.social_link_segments.find_by(segment_id: segment.id)
    social_link_segment.news_feed_link_segment.destroy
  end

  protected

  def correct_url?
    unless SocialMedia::Importer.valid_url? url
      errors.add(:url, 'is not a valid url for supported services')
    end
  end

  def add_trailing_slash
    self.url = File.join(self.url, '')
  end

  def populate_embed_code
    self.embed_code = SocialMedia::Importer.url_to_embed url
  end

  private

  def build_default_link
    return if group_id.nil?

    build_news_feed_link(news_feed_id: group.news_feed.id)
    true
  end

  def remove_news_feed_link
    news_feed_link.destroy if news_feed_link.present?
  end
end
