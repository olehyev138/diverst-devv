class FrequencyPeriod < BaseClass
  validates_length_of :name, maximum: 191
  validates_inclusion_of :name, in: ['second', 'minute', 'hour', 'day', 'week', 'month']
end
