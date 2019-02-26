Enterprise.all.each do |enterprise|
	spinner = TTY::Spinner.new("[:spinner] Populating groups with segments...", format: :classic)
    spinner.run('[DONE]') do |spinner|
		s = enterprise.segments.new(
		  name: 'Females'
		)

		s.rules.new(
		  field: enterprise.fields.where(title: 'Gender').first,
		  operator: SegmentRule.operators[:contains_any_of],
		  values: ['Female']
		)

		s.save

		CacheSegmentMembersJob.perform_now s.id
	end
end