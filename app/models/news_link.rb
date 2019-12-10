class NewsLink < ApplicationRecord
  include PublicActivity::Common

  belongs_to :group
  belongs_to :author, class_name: 'User'

  has_one :news_feed_link

  has_many :news_link_segments, dependent: :destroy
  has_many :segments, through: :news_link_segments, before_remove: :remove_segment_association
  has_many :news_link_photos,  dependent: :destroy
  has_many :user_reward_actions

  delegate :increment_view, to: :news_feed_link
  delegate :total_views, to: :news_feed_link
  delegate :unique_views, to: :news_feed_link

  before_validation :smart_add_url_protocol

  has_many :comments, class_name: 'NewsLinkComment', dependent: :destroy
  has_many :photos, class_name: 'NewsLinkPhoto', dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :news_feed_link, allow_destroy: true

  validates_length_of :description, maximum: 65535
  validates_length_of :title, maximum: 191
  validates :group_id,        presence: true
  validates :title,           presence: true
  validates :description,     presence: true
  validates :author_id,       presence: true
  validates :url,             length: { maximum: 191 }

  # ActiveStorage
  has_one_attached :picture
  validates :picture, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :picture_paperclip, s3_permissions: 'private'

  after_create :build_default_link
  after_destroy :remove_news_feed_link

  scope :of_segments, ->(segment_ids) {
    nl_condtions = ['news_link_segments.segment_id IS NULL']
    nl_condtions << "news_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN news_link_segments ON news_link_segments.news_link_id = news_links.id')
      .where(nl_condtions.join(' OR '))
  }

  scope :unapproved, -> { joins(:news_feed_link).where(news_feed_links: { approved: false }) }
  scope :approved, -> { joins(:news_feed_link).where(news_feed_links: { approved: true }) }

  def picture_location(expires_in: 3600, default_style: :medium)
    return nil if !picture.attached?

    # default_style = :medium if !picture.styles.keys.include? default_style
    # picture.expiring_url(expires_in, default_style)
    Rails.application.routes.url_helpers.url_for(picture)
  end

  # call back to delete news link segment associations
  def remove_segment_association(segment)
    news_link_segment = self.news_link_segments.find_by(segment_id: segment.id)
    news_link_segment.news_feed_link_segment.destroy
  end

  def comments_count
    if group.enterprise.enable_pending_comments?
      comments.approved.count
    else
      comments.count
    end
  end

  protected

  def smart_add_url_protocol
    return nil if url.blank?

    self.url = "http://#{url}" unless have_protocol?
  end

  def have_protocol?
    url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
  end

  def build_default_link
    return if news_feed_link.present?

    create_news_feed_link(news_feed_id: group.news_feed.id)
  end

  def remove_news_feed_link
    news_feed_link.destroy if news_feed_link.present?
  end
end
