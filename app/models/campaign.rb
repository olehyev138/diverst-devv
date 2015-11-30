class Campaign < ActiveRecord::Base
  belongs_to :enterprise
  has_many :questions
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :segments
  has_many :invitations, class_name: "CampaignInvitation"
  has_many :employees, through: :invitations
  has_many :answers, through: :questions
  has_many :answer_comments, through: :questions

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  after_create :create_invites

  def create_invites
    enterprise.employees.for_groups(self.groups).each do |employee_to_invite|
      self.invitations.create(employee: employee_to_invite)
    end
  end

  def contributions_per_erg
    series = [{
      name: "# of contributions",
      data: self.groups.map do |group|
        {
          name: group.name,
          y: self.answers.where(author_id: group.members.ids).count + self.answer_comments.where(author_id: group.members.ids).count
        }
      end
    }]

    return {
      series: series
    }
  end

  def top_performers
    top_answers_hash = self.answers.group(:author).count
    top_comments_hash = self.answer_comments.group('answer_comments.author_id').order('count_all').count.map{ |k, v| [Employee.find(k), v] }.to_h
    top_combined_hash = top_answers_hash.merge(top_comments_hash){ |k, a_value, b_value| a_value + b_value }

    series = [{
      name: "# of interactions",
      data: top_combined_hash.values
    }]

    return {
      series: series,
      categories: top_combined_hash.keys.map(&:name),
      xAxisTitle: "# of interactions"
    }
  end
end
