class Initiative < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :owner, class_name: "User"
  has_many :updates, class_name: "InitiativeUpdate", dependent: :destroy
  has_many :fields, as: :container, dependent: :destroy
  has_many :expenses, dependent: :destroy, class_name: "InitiativeExpense"

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true


  #Ported from Event
# todo: check events controller views and forms to work
# update admin fields to save new fields as well
# change name in admin to initiatives


  belongs_to :owner_group, class_name: 'Group'

  has_many :initiative_participating_groups
  has_many :participating_groups, through: :initiative_participating_groups, source: :group, class_name: 'Group'

  has_many :segments, through: :initiative_segments
  has_many :initiative_invitees
  has_many :invitees, through: :initiative_invitees, source: :user
  has_many :comments, class_name: 'InitiativeComment'

  has_many :initiative_users
  has_many :attendees, through: :initiative_users, source: :user

  scope :past, -> { where('end < ?', Time.current).order(start: :desc) }
  scope :upcoming, -> { where('start > ?', Time.current).order(start: :asc) }
  scope :ongoing, -> { where('start <= ?', Time.current).where('end >= ?', Time.current).order(start: :desc) }

  has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

  def time_string
    if start.to_date == self.end.to_date # If the initiative starts and ends on the same day
      "#{start.to_s :dateonly} from #{start.to_s :ampmtime} to #{self.end.to_s :ampmtime}"
    else
      "From #{start.to_s :datetime} to #{self.end.to_s :datetime}"
    end
  end

  # ENDOF port from Event


  def highcharts_history(field:, from: 1.year.ago, to: Time.current)
    self.updates
    .where('created_at >= ?', from)
    .where('created_at <= ?', to)
    .order(created_at: :asc)
    .map do |update|
      [
        update.created_at.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
        update.info[field]
      ]
    end
  end

  def expenses_highcharts_history(from: 1.year.ago, to: Time.current)
    highcharts_expenses = self.expenses
    .where('created_at >= ?', from)
    .where('created_at <= ?', to)
    .order(created_at: :asc)
    .map do |expense|
      [
        expense.created_at.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
        expense.amount
      ]
    end

    expenses_sum = 0

    highcharts_expenses.each_with_index do |hc_expense, i|
      next if i == 0
      hc_expense[1] += highcharts_expenses[i - 1][1]
    end
  end
end
