class Region < ApplicationRecord
  include ActionView::Helpers::TranslationHelper
  include PublicActivity::Common
  include Region::Actions

  belongs_to :parent, class_name: 'Group'
  has_many :children, class_name: 'Group', foreign_key: :region_id, dependent: :nullify
  has_one :enterprise, through: :parent

  has_many :region_leaders, class_name: 'GroupLeader', as: :leader_of, dependent: :destroy

  has_many :user_groups, through: :children
  has_many :members, -> { distinct }, through: :user_groups, class_name: 'User', source: :user
  has_many :annual_budgets, -> { with_expenses }, as: :budget_head
  has_many :annual_budgets_raw, dependent: :destroy, as: :budget_head, class_name: 'AnnualBudget'

  validates :name, presence: true
  validates :parent, presence: true
  validates_length_of :name, maximum: 191
  validates_length_of :home_message, maximum: 65535
  validates_length_of :short_description, maximum: 65535
  validates_length_of :description, maximum: 65535

  validate :ensure_parent_isnt_a_child_group

  after_create :set_position

  scope :is_private,        -> { where(private: true) }
  scope :non_private,       -> { where(private: false) }

  def current_annual_budget
    annual_budgets.where(closed: false).last || parent.current_annual_budget
  end

  def all_annual_budgets
    other = parent&.all_annual_budgets
    !other.nil? ? other.union(annual_budgets_raw) : annual_budgets_raw
  end

  def to_s
    name
  end

  def file_safe_name
    name.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  private

  def set_position
    self.position = self.id
  end

  def ensure_parent_isnt_a_child_group
    if parent.is_sub_group?
      errors.add(:parent, t('errors.region.parent_cant_be_child_group'))
    end
  end
end
