class Pillar < ActiveRecord::Base
  belongs_to :outcome
  has_many :initiatives, dependent: :destroy

  default_scope { includes(:outcome) }

  def name_with_group_prefix
    parent_group = outcome.group

    "(#{parent_group.name}) name"
  end
end