class Campaign < BaseClass
  include PublicActivity::Common

  enum status: [:published, :draft, :closed, :reopened]

  belongs_to :enterprise
  belongs_to :owner, class_name: 'User'
  has_many :questions, dependent: :destroy
  has_many :campaigns_groups, dependent: :destroy
  has_many :groups, through: :campaigns_groups
  has_many :campaigns_segments, dependent: :destroy
  has_many :segments, through: :campaigns_segments
  has_many :invitations, class_name: 'CampaignInvitation', dependent: :destroy
  has_many :users, through: :invitations
  has_many :answers, through: :questions
  has_many :answer_comments, through: :questions
  has_many :answer_upvotes, through: :questions
  has_many :campaigns_managers, dependent: :destroy
  has_many :managers, through: :campaigns_managers, source: :user
  has_many :sponsors, dependent: :destroy
  has_many :user_reward_actions, dependent: :destroy

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :sponsors, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: 'private'
  validates_length_of :banner_content_type, maximum: 191
  validates_length_of :banner_file_name, maximum: 191
  validates_length_of :image_content_type, maximum: 191
  validates_length_of :image_file_name, maximum: 191
  validates_length_of :description, maximum: 65535
  validates_length_of :title, maximum: 191
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner, styles: { medium: '1200x1200>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: 'private'
  validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}

  validates :title,       presence: true
  validates :description, presence: true
  validates :start,       presence: true
  validates :end,         presence: true
  validates :groups,      presence: { message: 'Please select at least 1 group' }

  validates :start,
            date: { after: Proc.new { Date.today }, message: 'must be after today' },
            on: [:create, :update]

  validates :end, date: { after: :start, message: 'must be after start' }, on: [:create, :update]

  after_create :create_invites, :send_invitation_emails

  scope :ongoing, -> { where('start < :current_time AND end > :current_time', current_time: Time.current) }
  scope :closed, -> { where('end < :current_time', current_time: Time.current) }

  # values obtained from enum field status defined above
  scope :valid_campaigns, -> { where(status: [0, 2, 3]) }

  # users with the most campaign engagement points
  def top_campaign_performers
    engaged_users = User.where(id: self.answers.pluck(:author_id) + self.answer_comments.pluck(:author_id) + self.answer_upvotes.pluck(:author_id)).uniq
    engaged_users.select { |u| u.campaign_engagement_points(self) > 0 }
                 .map { |u| [u.name, u.campaign_engagement_points(self)] }
                 .inject({}) { |hash, (u, p)| hash.merge(u => p) }
  end

  def response_percentage
    # unique count of engaged users/number of invitations
    no_of_engaged_users = User.where(id: self.answers.pluck(:author_id) + self.answer_comments.pluck(:author_id) + self.answer_upvotes.pluck(:author_id)).uniq.size
    no_of_invitations = self.invitations.size.to_f

    ((no_of_engaged_users / no_of_invitations) * 100).to_i
  end

  def engagement_activity_level
    # total number of answers, upvotes and comments across all questions for a campaign
    (self.answers.size * 10) + self.answer_upvotes.size + (self.answer_comments.size * 3)
  end

  def chosen_ideas
    self.answers.where(chosen: true)
  end

  def total_roi
    self.answers.where.not(value: nil).sum(:value)
  end

  def self.total_roi_for_all_campaigns(enterprise_id)
    enterprise = Enterprise.find_by(id: enterprise_id)
    enterprise.answers.where.not(value: nil).sum(:value)
  end

  def self.roi_distribution(enterprise_id, campaign_id, date_range)
    campaign = Campaign.find_by(id: campaign_id)
    enterprise = Enterprise.find_by(id: enterprise_id)

    date_range =

    case date_range
    when '1m'
      (DateTime.now << 1)..DateTime.now
    when '3m'
      (DateTime.now << 3)..DateTime.now
    when '6m'
      (DateTime.now << 6)..DateTime.now
    when '9m'
      (DateTime.now << 9)..DateTime.now
    when '1y'
      (DateTime.now << 12)..DateTime.now
    else
      enterprise.created_at..DateTime.now
    end

    campaigns = enterprise.campaigns.where(created_at: date_range)

    campaigns = campaigns.select { |c| c.total_roi > 0 }
                         .map { |c| [c.title, c.total_roi] }
                         .inject({}) { |hash, (c, roi)| hash.merge(c => roi) }

    return campaigns if campaign.nil?

    return if campaign.total_roi < 1

    # this ensures a particular order of hash elements for graphical representation
    campaign.total_roi > 0 ? campaigns = { campaign.title => campaign.total_roi }.merge(campaigns) : campaigns
  end

  def self.engagement_activity_distribution(enterprise_id, campaign_id, date_range)
    campaign = Campaign.find_by(id: campaign_id)
    enterprise = Enterprise.find_by(id: enterprise_id)

    date_range =

    case date_range
    when '1m'
      (DateTime.now << 1)..DateTime.now
    when '3m'
      (DateTime.now << 3)..DateTime.now
    when '6m'
      (DateTime.now << 6)..DateTime.now
    when '9m'
      (DateTime.now << 9)..DateTime.now
    when '1y'
      (DateTime.now << 12)..DateTime.now
    else
      enterprise.created_at..DateTime.now
    end

    campaigns = enterprise.campaigns.where(created_at: date_range)

    campaigns = campaigns.select { |c| c.engagement_activity_level > 0 }
                          .map { |c| [c.title, c.engagement_activity_level] }
                          .inject({}) { |hash, (c, eal)| hash.merge(c => eal) }

    return campaigns if campaign.nil?

    return if campaign if campaign.engagement_activity_level < 1

    # this ensures a particular order of hash elements for graphical representation
    campaign.engagement_activity_level > 0 ? campaigns = { campaign.title => campaign.engagement_activity_level }.merge(campaigns) : campaigns
  end

  def closed?
    self.end < Time.current
  end

  def create_invites
    return if enterprise.nil?

    invites = []

    targeted_users.each do |u|
      invites << CampaignInvitation.new(campaign: self, user: u)
    end

    CampaignInvitation.import invites
  end

  # Returns the list of users who meet the participation criteria for the poll
  def targeted_users
    if groups.any?
      target = []
      groups.each do |group|
        target << group.active_members
      end

      target.flatten!
      target_ids = target.map { |u| u.id }

      target = User.where(id: target_ids)
    else
      target = enterprise.users.active
    end

    target = target.for_segments(segments) unless segments.empty?

    target.uniq { |u| u.id }
  end

  def link
    "<a saml_for_enterprise=\"#{enterprise_id}\" href=\"#{Rails.application.routes.url_helpers.user_user_campaign_questions_url(self)}\" target=\"_blank\">Join Now</a>"
  end

  def send_invitation_emails
    if published?
      invitations.where(email_sent: false).find_each do |invitation|
        CampaignMailer.invitation(invitation).deliver_later
      end
    end
  end

  # Returns the % of questions that have been closed
  def progression
    return 0 if questions.size == 0

    (questions.solved.count.to_f / questions.size * 100).round
  end

  def contributions_per_erg_csv(erg_text)
    series = [{
      name: '# of contributions',
      data: groups.map do |group|
        {
          name: group.name,
          y: answers.where(author_id: group.members.ids).count + answer_comments.where(author_id: group.members.ids).count
        }
      end
    }]

    data = {
      series: series
    }

    flatten_data = data[:series].map { |d| d[:data] }.flatten
    strategy = Reports::GraphStatsGeneric.new(
      title: "Contributions per #{ erg_text }",
      categories: flatten_data.map { |d| d[:name] }.uniq,
      data: flatten_data.map { |d| d[:y] }
    )
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def top_performers_csv
    top_answers_count_hash = answers.group(:author).order('count_all').count

    top_answers_hash = top_answers_count_hash.map do |user, _|
      [
        user,
        answers.where(author: user).map { |a| a.votes.count }.sum
      ]
    end.to_h

    top_comments_hash = answer_comments.group('answer_comments.author_id').order('count_all').count.map { |k, v| [User.find(k), v] }.to_h
    top_combined_hash = top_answers_hash.merge(top_comments_hash) { |_k, a_value, b_value| a_value + b_value }.sort_by { |_k, v| v }.reverse!.to_h

    series = [{
      name: 'Score',
      data: top_combined_hash.values[0..14]
    }]

    data = {
      series: series,
      categories: top_combined_hash.keys.map(&:name)[0..14],
      xAxisTitle: 'Employee',
      yAxisTitle: 'Score'
    }

    strategy = Reports::GraphStatsGeneric.new(title: 'Top performers',
                                              categories: data[:categories], data: data[:series].map { |d| d[:data] }.flatten)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end
end
