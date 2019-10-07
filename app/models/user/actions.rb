require 'securerandom'

module User::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def send_reset_password_instructions
    raise BadRequestException.new 'Your password has already been reset. Please check your email for a link to update your password.' if self.reset_password_token.present?

    token = SecureRandom.urlsafe_base64(nil, false)
    self.reset_password_token = BCrypt::Password.create(token, cost: 11)
    self.reset_password_sent_at = Time.now
    self.save!
    # UserMailer.delay(:queue => "critical").send_reset_password_instructions(self, token)
    token
  end

  def valid_reset_password_token?(token)
    return false if token.blank?
    return false if reset_password_sent_at.blank?
    return false if Time.now - reset_password_sent_at > Rails.configuration.password_reset_time_frame.hours

    BCrypt::Password.new(reset_password_token) == token
  end

  def reset_password_by_token(user)
    self.password = user[:password]
    self.password_confirmation = user[:password_confirmation]
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    self
  end

  def invite!
    regenerate_access_token
    UserMailer.delay(queue: 'mailers').send_invitation(self)
  end

  module ClassMethods
    def base_query
      "#{self.table_name}.id LIKE :search OR LOWER(#{self.table_name}.first_name) LIKE :search OR LOWER(#{self.table_name}.last_name) LIKE :search
      OR LOWER(#{self.table_name}.email) LIKE :search"
    end

    def valid_scopes
      %w(active enterprise_mentors)
    end

    def signin(email, password)
      # check for an email and password
      raise BadRequestException.new 'Email and password required' unless email.present? && password.present?

      # find the user
      user = User.find_by(email: email.downcase)
      raise BadRequestException.new 'User does not exist' if user.nil?

      # verify the password
      unless user.valid_password?(password)
        raise BadRequestException.new 'Incorrect password'
      end

      # auditing
      user.sign_in_count += 1
      user.last_sign_in_at = DateTime.now
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      user.save!

      user
    end

    def find_user_by_email(diverst_request, params)
      user = User.find_by_email(params[:email]&.downcase)

      raise BadRequestException.new 'User does not exist' if user.nil?

      user
    end

    def posts(current_user, params)
      count = params[:count].to_i || 5
      page = params[:page].to_i || 0
      order = params[:order].to_sym rescue :desc
      order_by = params[:order_by].to_sym rescue :created_at

      # get the news_feed_ids
      news_feed_ids = NewsFeed.where(group_id: current_user.groups.ids).ids

      # get the news_feed_links
      nfls = NewsFeedLink
        .joins(:news_feed).joins(joins_query)
        .includes(:group_message, :news_link, :social_link)
        .where('news_feed_links.news_feed_id IN (?) OR shared_news_feed_links.news_feed_id IN (?)', news_feed_ids, news_feed_ids)
        .where(approved: true, archived_at: nil)
        .where(where_querey, current_user.segments.pluck(:id))
        .order(order_by => order)
        .distinct

      total = nfls.size
      paged = nfls.limit(count).offset(page * count)

      serialized = paged.map { |nfl| NewsFeedLinkSerializer.new(nfl).to_h }

      { page: {
        items: serialized,
        total: total,
        type: 'newsfeedlink'
      } }
    end

    private

    def where_querey
      'news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)'
    end

    def joins_query
      'LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id
     LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id'
    end

    def set_page
      @limit = 5
      @page = params[:page].present? ? params[:page].to_i : 1
      @limit *= @page
    end
  end
end
