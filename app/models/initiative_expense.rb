class InitiativeExpense < ApplicationRecord
  # belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  # belongs_to :budget_item
  belongs_to :budget_user
  has_one :budget_item, through: :budget_user
  has_one :budget, through: :budget_item
  has_one :annual_budget, through: :budget
  has_one :enterprise, through: :annual_budget
  delegate :group, to: :budget_user

  validates_length_of :description, maximum: 191
  # validates :initiative, presence: true
  # validates :annual_budget, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate -> { initiative_is_not_finalized }

  scope :finalized, -> { joins(:initiative).where(initiatives: { finished_expenses: true }) }
  scope :active, -> { joins(:initiative).where(initiatives: { finished_expenses: false }) }

  def initiative_is_not_finalized
    if budget_user&.budgetable.blank? || budget_user.budgetable.finished_expenses?
      errors.add(:initiative, "Can't #{new_record? ? 'add' : 'edit'} an expense for a closed initiative")
    end
  end

  def self.get_old_sums(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
      SET @old_spent = 0;
      SELECT IFNULL(spent, 0)
      FROM budget_users_sums
      WHERE budget_user_id = #{old_or_new}.budget_user_id
      INTO @old_spent;
    SQL
  end

  def self.set_new_sums(old_or_new = 'NEW')
    <<~SQL.gsub(/\s+/, ' ').strip
      REPLACE INTO budget_users_sums
      VALUES(#{old_or_new}.budget_user_id, IFNULL(@new_spent, 0));
    SQL
  end

  trigger.after(:insert) do
    <<~SQL.gsub(/\s+/, ' ').strip
      #{get_old_sums}
      SET @new_spent = @old_spent + NEW.amount;
      #{set_new_sums}
    SQL
  end

  trigger.after(:delete) do
    <<~SQL.gsub(/\s+/, ' ').strip
      #{get_old_sums('OLD')}
      SET @new_spent = @old_spent - OLD.amount;
      #{set_new_sums('OLD')}
    SQL
  end

  trigger.after(:update).of(:amount) do
    <<~SQL.gsub(/\s+/, ' ').strip
      #{get_old_sums}
      SET @new_spent = @old_spent + NEW.amount - OLD.amount;
      #{set_new_sums}
    SQL
  end
end
