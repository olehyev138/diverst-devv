class Campaign < ActiveRecord::Base
    include PublicActivity::Common

    enum status: [:published, :draft]

    belongs_to :enterprise
    belongs_to :owner, class_name: "User"
    has_many :questions, dependent: :destroy
    has_many :campaigns_groups, dependent: :destroy
    has_many :groups, through: :campaigns_groups
    has_many :campaigns_segments, dependent: :destroy
    has_many :segments, through: :campaigns_segments
    has_many :invitations, class_name: 'CampaignInvitation', dependent: :destroy
    has_many :users, through: :invitations
    has_many :answers, through: :questions
    has_many :answer_comments, through: :questions
    has_many :campaigns_managers, dependent: :destroy
    has_many :managers, through: :campaigns_managers, source: :user
    has_many :sponsors, as: :sponsorable, dependent: :destroy

    accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :sponsors, reject_if: :all_blank, allow_destroy: true

    has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: "private"
    validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

    has_attached_file :banner, styles: { medium: '1200x1200>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: "private"
    validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}

    validates :title,       presence: true
    validates :description, presence: true
    validates :start,       presence: true
    validates :end,         presence: true
    validates :groups,      presence: {:message => "Please select at least 1 group"}

    validates :start,
        date: { after: Proc.new { Date.today }, message: 'must be after today' },
        on: [:create, :update]

    validates :end, date: {after: :start, message: 'must be after start'}, on: [:create, :update]

    after_create :create_invites, :send_invitation_emails

    scope :ongoing, -> { where('start < :current_time AND end > :current_time', current_time: Time.current) }

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
        target_ids = target.map{|u| u.id}

        target = User.where(id: target_ids)
      else
        target = enterprise.users.active
      end

      target = target.for_segments(segments) unless segments.empty?

      target.uniq{|u| u.id}
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

    def contributions_per_erg_csv(erg_text)
      data = self.contributions_per_erg

      flatten_data = data[:series].map{ |d| d[:data] }.flatten
      strategy = Reports::GraphStatsGeneric.new(
        title: "Contributions per #{ erg_text }",
        categories: flatten_data.map{ |d| d[:name] }.uniq,
        data: flatten_data.map{ |d| d[:y] }
      )
      report = Reports::Generator.new(strategy)

      report.to_csv
    end

    def top_performers_csv
      data = self.top_performers

      strategy = Reports::GraphStatsGeneric.new(title: 'Top performers',
        categories: data[:categories], data: data[:series].map{ |d| d[:data] }.flatten)
      report = Reports::Generator.new(strategy)

      report.to_csv
    end
end
