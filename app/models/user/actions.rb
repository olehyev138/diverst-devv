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

  def sign_up(params)
    if update_attributes(params)
      update(invitation_token: nil, invitation_accepted_at: Time.now)
      self
    else
      raise InvalidInputException.new({ message: errors.full_messages.first, attribute: errors.messages.first.first })
    end
  end

  def posts(params)
    count = (params[:count] || 5).to_i
    page = (params[:page] || 0).to_i
    order = params[:order].to_sym rescue :desc
    order_by = params[:order_by].to_sym rescue :created_at

    # get the news_feed_ids
    news_feed_ids = NewsFeed.joins(:group).where(group_id: groups.ids, groups: { latest_news_visibility: ['group', 'public', 'global', 'non-members'] }).ids

    # get the news_feed_links
    base_nfls = NewsFeedLink
                  .preload(NewsFeedLink.base_preloads)
                  .left_joins(:news_feed_link_segments, :shared_news_feed_links)
                  .includes(:group_message, :news_link, :social_link)

    news_feed_or = []
    news_feed_or << NewsFeedLink.sql_where(news_feed_links: { news_feed_id: news_feed_ids })
    news_feed_or << NewsFeedLink.sql_where(shared_news_feed_links: { news_feed_id: news_feed_ids })

    segment_ors = []
    segment_ors << NewsFeedLink.sql_where(news_feed_link_segments: { segment_id: nil })
    segment_ors << NewsFeedLink.sql_where(
      news_feed_link_segments: { segment_id: segment_ids }
    )

    nfls = base_nfls
             .where(news_feed_or.join(' OR '))
             .where(approved: true, archived_at: nil)
             .where(segment_ors.join(' OR '))
             .order(order_by => order)
             .distinct

    total = nfls.size
    paged = nfls.limit(count).offset(page * count)

    Page.new(paged, total)
  end

  def downloads(params)
    count = (params[:count] || 10).to_i
    page = (params[:page] || 0).to_i
    order = params[:order].to_sym rescue :desc
    order_by = params[:order_by].to_sym rescue :created_at

    query_scopes = CsvFile.set_query_scopes(params)

    ordered = csv_files
                  .download_files
                  .send_chain(query_scopes)
                  .order(order_by => order)
                  .distinct

    total = ordered.size
    paged = ordered.limit(count).offset(page * count)

    Page.new(paged, total)
  end

  def index_except_self(params, serializer: UserSerializer)
    count = (params[:count] || 5).to_i
    page = (params[:page] || 0).to_i
    order = params[:order].to_sym rescue :desc
    order_by = params[:order_by].to_sym rescue :created_at
    scope =
      JSON.parse params[:query_scopes] || '[]'

    # get the users in scope
    if scope.class.to_s == 'Array'
      scoped_users = scope.reduce(User) { |sum, n| sum.send(n.to_sym) }
    elsif scope.respond_to?(:to_sym)
      scoped_users = User.send(scope.to_sym)
    else
      scoped_users = User
    end

    ordered = scoped_users
                .where.not(id: id)
                .order(order_by => order)
                .distinct

    total = ordered.size
    paged = ordered.limit(count).offset(page * count)

    Page.new(paged, total)
  end

  module ClassMethods
    # Export a CSV with the specified users
    def csv_attributes(current_user = nil, params = {})
      fields = current_user.present? ? current_user.fields : Field.none
      current_user.field_data.load if current_user.present?
      {
          titles: ['First name',
                   'Last name',
                   'Email',
                   'Biography',
                   'Active',
                   'Group Membership'
          ].concat(fields.map(&:title)),
          values: [
              :first_name,
              :last_name,
              :email,
              :biography,
              :active,
              -> (user) { user.groups.map(&:name).join(',') },
          ].concat(
              fields.map do |field|
                -> (user) { field.csv_value(user[field]) }
              end
            )
      }
    end

    def parameter_name(scope)
      scope_map = {
          all: 'all',
          active: 'active',
          inactive: 'inactive',
          saml: 'sso authorized',
          invitation_sent: 'pending'
      }

      case scope
      when String, Symbol
        scope_map[scope.to_sym] || scope
      when Array
        case scope.first
        when 'of_role' then UserRole.find(scope.second).first.role_name.downcase
        else scope.first
        end
      else
        raise ::ArgumentError.new('query scopes should be an array of either strings or arrays starting with a string')
      end
    end

    def base_query
      "#{ self.table_name }.id LIKE :search OR LOWER(#{ self.table_name }.first_name) LIKE :search OR LOWER(#{ self.table_name }.last_name) LIKE :search"\
      " OR LOWER(#{ self.table_name }.email) LIKE :search"
    end

    def valid_scopes
      %w( enterprise_mentors mentors mentees accepting_mentee_requests accepting_mentor_requests
          all active inactive saml invitation_sent of_role)
    end

    def preload_attachments
      [:avatar]
    end

    def base_preloads
      [
          :field_data,
          :enterprise,
          :user_groups,
          :user_role,
          :news_links,
          :avatar_attachment,
          :avatar_blob,
          field_data: [
                  :field,
                  { field: Field.base_preloads }
              ],
          enterprise: [
                  :theme,
                  :mobile_fields
              ]
      ]
    end

    def base_attribute_preloads
      [
          :user_role,
          :enterprise,
          :news_links,
          :avatar_attachment,
          {
              enterprise: [
                  :theme,
                  :mobile_fields
              ]
          }
      ]
    end

    def mentor_lite_includes
      [:mentoring_interests, :mentoring_types, :availabilities]
    end

    def mentor_includes
      [:mentoring_interests, :mentoring_types, :mentors, :mentees, :mentorship_ratings, :availabilities,
       mentors: mentor_lite_includes, mentees: mentor_lite_includes]
    end

    def signin(email, password, request = nil)
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
      user.last_sign_in_ip = user.current_sign_in_ip
      if request
        user.current_sign_in_ip = request.remote_ip
      end
      user.save!

      user
    end

    def find_user_by_email(diverst_request, params)
      user = User.find_by_email(params[:email]&.downcase)

      raise BadRequestException.new 'User does not exist' if user.nil?

      user
    end
  end
end
