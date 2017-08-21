class Initiative < ActiveRecord::Base
  include PublicActivity::Common

  attr_accessor :associated_budget_id

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

  belongs_to :budget_item
  has_one :budget, through: :budget_item

  has_many :checklists, as: :subject
  has_many :resources, as: :container

  has_many :checklist_items, as: :container
  accepts_nested_attributes_for :checklist_items, reject_if: :all_blank, allow_destroy: true

  belongs_to :owner_group, class_name: 'Group'

  has_many :initiative_segments
  has_many :segments, through: :initiative_segments
  has_many :initiative_participating_groups
  has_many :participating_groups, through: :initiative_participating_groups, source: :group, class_name: 'Group'

  has_many :initiative_invitees
  has_many :invitees, through: :initiative_invitees, source: :user
  has_many :comments, class_name: 'InitiativeComment'

  has_many :initiative_users
  has_many :attendees, through: :initiative_users, source: :user

  has_one :outcome, through: :pillar

  scope :past, -> { where('end < ?', Time.current).order(start: :desc) }
  scope :upcoming, -> { where('start > ?', Time.current).order(start: :asc) }
  scope :ongoing, -> { where('start <= ?', Time.current).where('end >= ?', Time.current).order(start: :desc) }
  scope :recent, -> { where(created_at: 60.days.ago..Date.tomorrow) }
  scope :of_segments, ->(segment_ids) {
    initiative_conditions = ["initiative_segments.segment_id IS NULL"]
    initiative_conditions << "initiative_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins("LEFT JOIN initiative_segments ON initiative_segments.initiative_id = initiatives.id")
      .where(initiative_conditions.join(" OR "))
  }

  before_create :allocate_budget_funds

  has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}
  validates :start, presence: true
  validates :end, presence: true
  validate :check_budget
  validate :segment_enterprise

  def initiative_date(date_type)
    return "" unless ["start", "end"].include?(date_type)
    self.send(date_type).blank? ? "" : self.send(date_type).to_s(:reversed_slashes)
  end

  def group
    owner_group || pillar.outcome.group
  end

  #need to trunc several special characters here
  def description
    d = self[:description]

    d.gsub! '<p>', ''
    d.gsub! '</p>', ''
    d.gsub! '&nbsp', ''
  end

  def budget_status
    budget.try(:status_title) || "Not attached"
  end

  def expenses_status
    if finished_expenses?
      'Expenses finished'
    else
      'Expenses in progress'
    end
  end

  def approved?
    !pending?
  end

  def pending?
    # If there is no budget for event then it needs no money and no approval
    return false if budgets.empty?

    # Check if there are anu budget that is not yet approved
    budgets.any? { |budget| ! budget.is_approved }
  end

  def finish_expenses!
    return false if finished_expenses?

    leftover = estimated_funding - current_expences_sum
    group.leftover_money += leftover
    group.save
    self.update(finished_expenses: true)
  end

  def current_expences_sum
    expenses.sum(:amount) || 0
  end

  def leftover
    estimated_funding - current_expences_sum
  end

  def title
    name
  end

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
        update.reported_for_date.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
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

  def funded_by_leftover?
    self.budget_item_id == BudgetItem::LEFTOVER_BUDGET_ITEM_ID
  end

  protected

  def update_owner_group
    return true if self.owner_group_id

    self.owner_group_id = self.pillar.try(:outcome).try(:group).try(:id)
  end

  def check_budget
    # We don't need budgets for events without allocate_budget_funds
    return true if estimated_funding == 0

    if budget.present?
      if budget.subject != group
        # make sure noone is trying to put incorrect budget value
        errors.add(:budget, 'You are providing wrong budget')
        return false
      end

      return true
    end

    if funded_by_leftover?
      return true
    end

    # Here we know there is no budge, no leftover, but estimated_amount
    # is still greater than zero, which is not valid
    errors.add(:budget, 'Can not create event with funds but without budget')
  end

  def segment_enterprise
    segments.each do |segment|
      if segment.try(:enterprise) != owner.try(:enterprise)
        errors.add(:segments, 'has invalid segments')
        return
      end
    end
  end

  def allocate_budget_funds
    if budget_item.present?
      self.estimated_funding = budget_item.available_amount
      budget_item.available_amount = 0
      budget_item.is_done = true

      budget_item.save
    elsif funded_by_leftover?
      self.estimated_funding = owner_group.leftover_money
      owner_group.leftover_money = 0

      owner_group.save
    else
      self.estimated_funding = 0
    end
  end
end
