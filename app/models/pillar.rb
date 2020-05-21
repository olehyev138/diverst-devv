class Pillar < BaseClass
  belongs_to :outcome
  has_many :initiatives, dependent: :destroy

  validates_length_of :value_proposition, maximum: 191
  validates_length_of :name, maximum: 191

  def name_with_group_prefix
    parent_group = outcome.group

    "(#{parent_group.name}) #{name}"
  end
end
