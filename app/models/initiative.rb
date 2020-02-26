class Initiative < BaseClass
  include PublicActivity::Common

  attr_accessor :associated_budget_id, :skip_allocate_budget_funds, :from, :to

  belongs_to :pillar
  belongs_to :owner, class_name: 'User'
  has_many :updates, class_name: 'InitiativeUpdate', dependent: :destroy
  has_many :fields, dependent: :delete_all
  has_many :expenses, dependent: :destroy, class_name: 'InitiativeExpense'
  has_many :user_reward_actions

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  validates_length_of :location, maximum: 191
  validates_length_of :picture_content_type, maximum: 191
  validates_length_of :picture_file_name, maximum: 191
  validates_length_of :description, maximum: 65535
  validates_length_of :name, maximum: 191
  validates :end, date: { after: :start, message: 'must be after start' }, on: [:create, :update]

  # Ported from Event
  # todo: check events controller views and forms to work
  # update admin fields to save new fields as well
  # change name in admin to initiatives

  belongs_to :budget_item
  has_one :budget, through: :budget_item

  has_many :checklists, dependent: :destroy
  has_many :resources, dependent: :destroy

  has_many :checklist_items, dependent: :destroy
  accepts_nested_attributes_for :checklist_items, reject_if: :all_blank, allow_destroy: true

  belongs_to :owner_group, class_name: 'Group'
  belongs_to :annual_budget

  has_many :initiative_segments, dependent: :destroy
  has_many :segments, through: :initiative_segments
  has_many :initiative_participating_groups, dependent: :destroy
  has_many :participating_groups, through: :initiative_participating_groups, source: :group, class_name: 'Group'

  has_many :initiative_invitees, dependent: :destroy
  has_many :invitees, through: :initiative_invitees, source: :user
  has_many :comments, class_name: 'InitiativeComment', dependent: :destroy

  has_many :initiative_users, dependent: :destroy
  has_many :attendees, through: :initiative_users, source: :user

  has_one :outcome, through: :pillar

  scope :starts_between, ->(from, to) { where('start >= ? AND start <= ?', from, to) }
  scope :past, -> { where('end < ?', Time.current).order(start: :desc) }
  scope :upcoming, -> { where('start > ? AND archived_at IS NULL', Time.current).order(start: :asc) }
  scope :ongoing, -> { where('start <= ? AND archived_at IS NULL', Time.current).where('end >= ?', Time.current).order(start: :desc) }
  scope :recent, -> { where(created_at: 60.days.ago..Date.tomorrow, archived_at: nil) }
  scope :of_segments, ->(segment_ids) {
    initiative_conditions = ['initiative_segments.segment_id IS NULL']
    initiative_conditions << "initiative_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN initiative_segments ON initiative_segments.initiative_id = initiatives.id')
    .where(initiative_conditions.join(' OR '))
  }
  scope :order_recent, -> { order(start: :desc) }
  scope :all_upcoming_events_for_group, ->(group_id) {
    group = Group.find(group_id)
    upcoming_events = group.initiatives.upcoming.limit(3) + group.participating_initiatives.upcoming.limit(3)
    upcoming_events.uniq
  }

  scope :all_ongoing_events_for_group, ->(group_id) {
    group = Group.find(group_id)
    ongoing_events = group.initiatives.ongoing + group.participating_initiatives.ongoing
    ongoing_events.uniq
  }

  scope :all_past_events_for_group, ->(group_id) {
    group = Group.find(group_id)
    past_events = group.initiatives.past + group.participating_initiatives.past
    past_events.uniq
  }

  # we don't want to run this callback when finish_expenses! is triggered in initiatives_controller.rb, finish_expense action
  before_save { allocate_budget_funds unless skip_allocate_budget_funds }

  # Slack Call Back
  after_create :post_new_event_to_slack, unless: Proc.new { Rails.env.test? }

  after_destroy :update_annual_budget

  has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: 'private'
  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :video
  do_not_validate_attachment_file_type :video


  validates :start, presence: true
  validates :end, presence: true
  validates :max_attendees, numericality: { greater_than: 0, allow_nil: true }
  validate :check_budget
  validate :segment_enterprise
  validates_presence_of :pillar

  settings do
    mappings dynamic: false do
      indexes :name, type: :keyword
      indexes :created_at, type: :date
      indexes :pillar do
        indexes :outcome do
          indexes :group do
            indexes :id, type: :integer
            indexes :enterprise_id, type: :integer
            indexes :parent_id, type: :integer
            indexes :name, type: :keyword
            indexes :parent do
              indexes :name, type: :keyword
            end
          end
        end
      end
    end
  end

  def ended?
    self.end < DateTime.now
  end

  def archived?
    archived_at.present?
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:name, :created_at],
        include: { pillar: { include: { outcome: { include: { group: {
          only: [:id, :enterprise_id, :parent_id, :name],
          include: { parent: { only: [:name] } }
        } }, only: [] }, }, only: [] } }
      )
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end

  def initiative_date(date_type)
    return '' unless ['start', 'end'].include?(date_type)

    self.send(date_type).blank? ? '' : self.send(date_type).to_s(:reversed_slashes)
  end

  def group
    owner_group || pillar.outcome.group
  end

  def enterprise
    group.enterprise
  end

  def group_id
    group.id
  end

  def enterprise_id
    enterprise.id
  end

  # need to trunc several special characters here
  def description
    return '' if self[:description].nil?

    d = self[:description]

    # Remove the trunc because we're allowing HTML and then sanitizing
    # d.gsub! '<p>', ''
    # d.gsub! '</p>', ''
    # d.gsub! '&nbsp;', ''

    d
  end

  def budget_status
    budget.try(:status_title) || 'Not attached'
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
    return false if budget.nil?

    # Check if budget is approved
    budget.is_approved
  end

  def finish_expenses!
    return false if finished_expenses?

    leftover_of_annual_budget = (owner_group.annual_budget - owner_group.approved_budget) + owner_group.available_budget
    group.leftover_money = leftover_of_annual_budget
    group.save
    self.update(finished_expenses: true)
  end

  def unfinished_expenses?
    (self.end < Time.current) && !finished_expenses?
  end

  def current_expences_sum
    annual_budget = self.annual_budget
    expenses.where(annual_budget_id: annual_budget.id).sum(:amount) || 0
  end

  def has_no_estimated_funding?
    estimated_funding == 0
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

  def self.to_csv(initiatives:, enterprise: nil)
    # initiative column titles
    CSV.generate(headers: true) do |csv|
      # These names dont correspond to the UI. Pillar = Outcome, Initiative/Program = Pillar, Event = Initiative
      csv << [
        enterprise.custom_text.send('erg_text'),
        enterprise.custom_text.send('outcome_text'),
        enterprise.custom_text.send('program_text'),
        'Event Name', 'Start Date', 'End Date',
        'Expenses', 'Budget', 'Metrics'
      ]

      initiatives.order(:start).each do |initiative|
        # initiative column values
        columns = [
          initiative.group.name,
          initiative.pillar.outcome.name,
          initiative.pillar.name,
          initiative.name,
          initiative.initiative_date('start'), initiative.initiative_date('end'),
          ActionController::Base.helpers.number_to_currency(initiative.expenses.sum(:amount)),
          ActionController::Base.helpers.number_to_currency(initiative.estimated_funding)
        ]

        if initiative.updates.any?
          update_data = initiative.updates.last.data
          data_set = update_data.gsub!(/[^0-9]/, ' ').strip.split(' ')
          data_set_hash = Hash[*data_set]

          metrics_data = []
          data_set_hash.each do |x|
            metrics_data << "#{Field.find([*x][0]).title}(#{[*x][1]})"
          end
          columns << metrics_data.to_s.gsub!(/[^A-Za-z0-9()]/, ' ').strip
        end

        csv << columns
      end
    end
  end

  # ENDOF port from Event

  def all_updates_fields
    updates_fields = self.updates.map { |update| update.info.keys }
    updates_fields.inject([], :|)
  end

  def highcharts_history(field:, from: 1.year.ago, to: Time.current)
    self.updates
    .where('report_date >= ?', from)
    .where('report_date <= ?', to)
    .order(created_at: :asc)
    .map do |update|
      [
        update.reported_for_date.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
        update.info[field]
      ]
    end
  end

  def highcharts_history_all_fields(fields: [], from: 1.year.ago, to: Time.current)
    series = []
    fields.each do |field|
      values = self.updates.where('report_date >= ?', from).where('report_date <= ?', to).order(created_at: :asc).map do |update|
        {
          x: update.reported_for_date.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
          y: update.info[field],
          children: {}
        }
      end
      values.select! { |pair| pair[:y].present? }
      values.sort_by! { |pair| pair[:x] }
      series += [{
        key: Field.find(field).title,
        values: values
      }]
    end
    series
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

  def group_ids
    participating_groups.pluck(:id) + [group.id]
  end

  def full?
    return self.attendees.count >= max_attendees if max_attendees?

    false
  end

  def expenses_time_series_csv(time_from = nil, time_to = nil)
    data = self.expenses_highcharts_history(
      from: time_from ? Time.at(time_from.to_i / 1000) : 1.year.ago,
      to: time_to ? Time.at(time_to.to_i / 1000) : Time.current
    )

    strategy = Reports::GraphTimeseriesGeneric.new(title: 'Expenses over time', data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def field_time_series_csv(field_id, time_from = nil, time_to = nil)
    field = Field.find(field_id)
    from = Time.at(time_from / 1000) rescue nil
    to = Time.at(time_to / 1000) rescue nil
    data = self.highcharts_history(
      field: field,
      from: from || 1.year.ago,
      to: to || Time.current + 1.day
    )

    strategy = Reports::GraphTimeseriesGeneric.new(data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def text_description
    HtmlHelper.to_pain_text(description)
  end

  def mrkdwn_description
    HtmlHelper.to_mrkdwn(description)
  end

  def to_slack_block(modifier: '')
    [
      slack_block_title(modifier: modifier)
        .merge(slack_block_image)
        .merge(slack_time_frame),
      slack_view_event_button,
      slack_last_updated
    ]
  end

  protected

  def slack_block_title(modifier: '')
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: "*#{modifier} Event: #{name}*\n#{mrkdwn_description}"
      }
    }
  end

  def slack_block_image
    if picture_file_name.present?
      {
        accessory: {
          type: 'image',
          image_url: picture.expiring_url(5.days),
          alt_text: 'Event Picture'
        }
      }
    else
      {}
    end
  end

  def slack_time_frame
    {
      fields: [
        {
          type: 'mrkdwn',
          text: "*Start Time*\n#{start.strftime('%F %T')}"
        },
        {
          type: 'mrkdwn',
          text: "*End Time*\n#{self.end.strftime('%F %T')}"
        }
      ]
    }
  end

  def slack_view_event_button
    {
      type: 'actions',
      elements: [
        {
          type: 'button',
          text: {
            type: 'plain_text',
            emoji: true,
            text: 'View Event'
          },
          url: group_event_url(group.id, id),
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

  def update_owner_group
    return true if self.owner_group_id

    self.owner_group_id = self.pillar.try(:outcome).try(:group).try(:id)
  end

  def check_budget
    # We don't need budgets for events without allocate_budget_funds
    return true if estimated_funding == 0

    if budget.present?

      if budget.group_id != group.id
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
    self.estimated_funding = 0.0 if self.estimated_funding.nil?

    if budget_item.present?
      # If user tries to allocate all the money from the budget
      # mark this budget item as used up
      if self.finished_expenses?
        errors.add(:budget_item_id, "sorry, can't choose another budget item")
        return false
      end

      if self.estimated_funding == 0.0 || self.estimated_funding >= budget_item.available_amount
        self.estimated_funding = budget_item.available_amount
        budget_item.available_amount = 0
        budget_item.is_done = true
      else
        # otherwise just subtract
        budget_item.available_amount -= self.estimated_funding
      end

      budget_item.save
    elsif funded_by_leftover?
      if self.estimated_funding >= owner_group.leftover_money
        self.estimated_funding = owner_group.leftover_money
      else
        owner_group.leftover_money -= self.estimated_funding
      end

      owner_group.save
    else
      # Else there is no source for money, so set funding to zero
      self.estimated_funding = 0
    end
  end

  def self.archived_initiatives(enterprise)
    enterprise.initiatives.where.not(archived_at: nil)
  end

  def self.archive_expired_events(group)
    return unless group.auto_archive?

    expiry_date = DateTime.now.send("#{group.unit_of_expiry_age}_ago", group.expiry_age_for_events)
    initiatives = group.initiatives.where('end < ?', expiry_date).where(archived_at: nil)

    initiatives.update_all(archived_at: DateTime.now) if initiatives.any?
  end

  private

  def post_new_event_to_slack
    pk, _ = enterprise.get_colours
    message = {
      attachments: [
        {
          fallback: "New Event for #{group.name}",
          color: pk,
          blocks: to_slack_block(modifier: 'New')
        }
      ]
    }
    group.send_slack_webhook_message message
    participating_groups.each do |gr|
      gr.send_slack_webhook_message message
    end
  end

  def update_annual_budget
    group = owner_group
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id)
    return if annual_budget.nil?

    leftover_of_annual_budget = ((group.annual_budget || annual_budget.amount) - group.approved_budget) + group.available_budget
    group.update(leftover_money: leftover_of_annual_budget, annual_budget: annual_budget.amount)
    annual_budget.update(amount: group.annual_budget, available_budget: group.available_budget,
                         leftover_money: group.leftover_money, expenses: group.spent_budget,
                         approved_budget: group.approved_budget)
  end
end
