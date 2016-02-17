enterprise = Enterprise.last

s = enterprise.segments.new(
  name: 'Females'
)

s.rules.new(
  field: enterprise.fields.where(title: 'Gender').first,
  operator: SegmentRule.operators[:contains_any_of],
  values: ['Female']
)

s.save

CacheSegmentMembersJob.perform_now s
