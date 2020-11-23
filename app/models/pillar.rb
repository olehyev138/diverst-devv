class Pillar < ApplicationRecord
  include Pillar::Actions

  belongs_to :outcome, inverse_of: :pillars
  has_one :group, through: :outcome
  has_many :initiatives, dependent: :destroy, inverse_of: :pillar

  validates_length_of :value_proposition, maximum: 191
  validates_length_of :name, maximum: 191

  delegate :group_id, to: :outcome

  def name_with_group_prefix
    parent_group = outcome.group

    "(#{parent_group.name}) #{name}"
  end

  def group
    if association(:group).loaded? || !association(:outcome).loaded?
      super
    else
      outcome.group
    end
  end
end
