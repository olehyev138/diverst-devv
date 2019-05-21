class Pillar < BaseClass
  belongs_to :outcome
  has_many :initiatives, dependent: :destroy

  def name_with_group_prefix
    parent_group = outcome.group

    "(#{parent_group.name}) #{name}"
  end
end
