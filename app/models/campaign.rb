class Campaign < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :enterprise
  belongs_to :owner, class_name: "User"
  has_many :questions
  has_many :campaigns_groups
  has_many :groups, through: :campaigns_groups
  has_many :campaigns_segments
  has_many :segments, through: :campaigns_segments
  has_many :invitations, class_name: 'CampaignInvitation'
  has_many :users, through: :invitations
  has_many :answers, through: :questions
  has_many :answer_comments, through: :questions
  has_many :campaigns_managers
  has_many :managers, through: :campaigns_managers, source: :user

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner, styles: { medium: '1200x1200>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}

  after_create :create_invites, :send_invitation_emails

  scope :ongoing, -> { where('start < :current_time AND end > :current_time', current_time: Time.current) }

  def create_invites
    return if enterprise.nil?

    invites = enterprise.users.for_groups(groups).map do |user_to_invite|
      CampaignInvitation.new(campaign: self, user: user_to_invite)
    end

    CampaignInvitation.import invites
  end

  def send_invitation_emails
    invitations.where(email_sent: false).find_each do |invitation|
      CampaignMailer.invitation(invitation).deliver_later
    end
  end

  def contributions_per_erg
    series = [{
      name: '# of contributions',
      data: groups.map do |group|
        {
          name: group.name,
          y: answers.where(author_id: group.members.ids).count + answer_comments.where(author_id: group.members.ids).count
        }
      end
    }]

    {
      series: series
    }
  end

  def top_performers
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

    {
      series: series,
      categories: top_combined_hash.keys.map(&:name)[0..14],
      xAxisTitle: 'Employee',
      yAxisTitle: 'Score'
    }
  end

  # Returns the % of questions that have been closed
  def progression
    return 0 if questions.count == 0
    (questions.solved.count.to_f / questions.count * 100).round
  end
end
