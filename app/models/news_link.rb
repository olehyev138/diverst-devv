class NewsLink < BaseClass
  include PublicActivity::Common

  belongs_to :group
  belongs_to :author, class_name: 'User', counter_cache: :own_news_links_count

  has_one :news_feed_link
  has_many :news_tags, through: :news_feed_link

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

  validates_length_of :picture_content_type, maximum: 191
  validates_length_of :picture_file_name, maximum: 191
  validates_length_of :description, maximum: 65535
  validates_length_of :title, maximum: 191
  validates :group_id,        presence: true
  validates :title,           presence: true
  validates :description,     presence: true
  validates :author_id,       presence: true
  validates :url,             length: { maximum: 191 }

  has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, s3_permissions: :private
  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

  after_create :build_default_link
  after_create :post_new_news_link_to_slack, unless: Proc.new { Rails.env.test? }
  after_destroy :remove_news_feed_link

  scope :of_segments, ->(segment_ids) {
    nl_condtions = ['news_link_segments.segment_id IS NULL']
    nl_condtions << "news_link_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN news_link_segments ON news_link_segments.news_link_id = news_links.id')
      .where(nl_condtions.join(' OR '))
  }

  scope :unapproved, -> { joins(:news_feed_link).where(news_feed_links: { approved: false }) }
  scope :approved, -> { joins(:news_feed_link).where(news_feed_links: { approved: true }) }

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

  def text_description
    HtmlHelper.to_pain_text(description)
  end

  def mrkdwn_description
    HtmlHelper.to_mrkdwn(description)
  end

  def to_slack_block(modifier: '')
    [
      slack_block_title(modifier: modifier),
      slack_block_author,
      slack_block_content,
      # .merge(slack_block_image),
      slack_block_buttons,
    ]
  end

  protected

  def slack_block_title(modifier: '')
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: "*#{modifier} News Link Shared from <#{group_url(group)}|#{group.name}>*:\n\t*<#{comments_group_news_link_url(group.id, id)}|#{title}>*\n\t*Link:* #{url}"
      }
    }
  end

  def slack_block_content
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: "#{mrkdwn_description}"
      }
    }
  end

  def slack_block_author
    {
      type: 'context',
      elements: [
        {
          type: 'mrkdwn',
          text: "*Poster:* #{author.name}"
        }
      ]
    }
  end

  def slack_block_image
    if picture_file_name.present?
      {
        accessory: {
          type: 'image',
          image_url: picture.url,
          alt_text: 'Event Picture'
        }
      }
    else
      {}
    end
  end

  def slack_block_buttons
    {
      type: 'actions',
      elements: [
        {
          type: 'button',
          text: {
            type: 'plain_text',
            emoji: true,
            text: 'View Comments'
          },
          url: comments_group_news_link_url(group.id, id),
          style: 'primary'
        },
        {
          type: 'button',
          text: {
            type: 'plain_text',
            emoji: true,
            text: 'Open News Link'
          },
          url: url,
          style: 'primary'
        }
      ]
    }
  end

  def slack_last_updated
    {
      type: 'context',
      elements: [
        {
          type: 'mrkdwn',
          text: "Last updated: #{updated_at.strftime('%F %T')}"
        }
      ]
    }
  end

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

  def post_new_news_link_to_slack
    pk, _ = group.enterprise.get_colours
    message = {
      attachments: [
        {
          fallback: "New News Link from #{group.name}",
          color: pk,
          blocks: to_slack_block(modifier: 'New')
        }
      ]
    }
    group.send_slack_webhook_message message
    news_feed_link.shared_news_feeds.each do |nf|
      nf.group.send_slack_webhook_message message
    end
  end
end
