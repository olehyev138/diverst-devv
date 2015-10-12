s = Enterprise.first.segments.new(
  name: "Females"
)

s.rules.new(
  field: SelectField.where(title: "Gender").first,
  operator: SegmentRule.operators[:contains_any_of],
  values: ["Female"]
)

s.save

CacheSegmentMembersJob.perform_now s