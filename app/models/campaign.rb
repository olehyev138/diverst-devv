class Campaign < ActiveRecord::Base
  belongs_to :enterprise
  belongs_to :admin
  has_many :questions
  has_many :campaigns_groups
  has_many :groups, through: :campaigns_groups
  has_many :campaigns_segments
  has_many :segments, through: :campaigns_segments
  has_many :invitations, class_name: 'CampaignInvitation'
  has_many :employees, through: :invitations
  has_many :answers, through: :questions
  has_many :answer_comments, through: :questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('missing.png')
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner, styles: { medium: '1200x1200>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('missing.png')
  validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}

  after_create :create_invites

  def create_invites
    invites = enterprise.employees.for_groups(groups).map do |employee_to_invite|
      CampaignInvitation.new(campaign: self, employee: employee_to_invite)
    end

    CampaignInvitation.import invites
  end

  def send_invitation_emails
    invitations.where(email_sent: false).find_each do |invitation|
      CampaignMailer.invitation(invitation).deliver_now
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

    top_answers_hash = top_answers_count_hash.map do |employee, _|
      [
        employee,
        answers.where(author: employee).map { |a| a.votes.count }.sum
      ]
    end.to_h

    top_comments_hash = answer_comments.group('answer_comments.author_id').order('count_all').count.map { |k, v| [Employee.find(k), v] }.to_h
    top_combined_hash = top_answers_hash.merge(top_comments_hash) { |_k, a_value, b_value| a_value + b_value }.sort_by { |_k, v| v }.reverse!.to_h

    series = [{
      name: '# of interactions',
      data: top_combined_hash.values
    }]

    {
      series: series,
      categories: top_combined_hash.keys.map(&:name),
      xAxisTitle: '# of interactions'
    }
  end

  # Returns the % of questions that have been closed
  def progression
    return 0 if questions.count == 0
    (questions.solved.count.to_f / questions.count * 100).round
  end
end
