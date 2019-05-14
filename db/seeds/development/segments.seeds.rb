after 'development:enterprise' do
  segments = [
    {
      name: "Males",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'Gender').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Male'].to_json
        }
      ]
    },
    {
      name: "Females",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'Gender').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Female'].to_json
        }
      ]
    },
    {
      name: "Northeast",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'Chapter').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Boston', 'Montreal', 'New York'].to_json
        }
      ]
    },
    {
      name: "Veterans",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'Veteran?').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Yes'].to_json
        }
      ]
    },
    {
      name: "Married",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'Status').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Married'].to_json
        }
      ]
    },
    {
      name: "LGBT",
      rules: [
        {
          field: -> (enterprise) { enterprise.fields.where(title: 'LGBT?').first },
          operator: SegmentRule.operators[:contains_any_of],
          values: ['Yes'].to_json
        }
      ]
    }
  ]

  spinner = TTY::Spinner.new(":spinner Populating enterprises with segments...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      segments.each do |segment|
        s = enterprise.segments.new(
          name: enterprise.name == "Diverst Inc" ? segment[:name] : "BAD ENTERPRISE " + segment[:name],
          created_at: Faker::Time.between(2.years.ago, 2.days.ago)
        )

        segment[:rules].each do |rule|
          s.field_rules.new(
            field: rule[:field].call(enterprise),
            operator: rule[:operator],
            values: rule[:values]
          )
        end

        s.save
      end
    end
    spinner.success("[DONE]")
  end
end