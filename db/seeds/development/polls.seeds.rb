after 'development:segments' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with polls...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      p = enterprise.polls.new(
        title: 'New Latino attraction at Disney World',
        description: "We’re planning on building a new attraction at Disney World before the beginning of summer. Since this park receives a significant amount of hispanic visitors each year, we want to make sure it doesn’t clash with their culture and is appealing to them.",
        groups: [enterprise.groups.first],
        segments: [enterprise.segments.first],
        status: 0,
        created_at: Faker::Time.between(enterprise.created_at + 1.day, 2.days.ago),
        owner: enterprise.users.sample,
        nb_invitations: 10
      )

      p.fields.new(
        type: 'SelectField',
        title: 'Would you download an app for attractions, food and ride?',
        saml_attribute: '',
        gamification_value: 10,
        show_on_vcard: false,
        match_exclude: true,
        match_polarity: true,
        match_weight: 0.2,
        options_text: "Yes
No"
      )

      p.fields.new(
        type: 'SelectField',
        title: "What’s an acceptable surcharge for the added attraction?",
        saml_attribute: '',
        gamification_value: 10,
        show_on_vcard: false,
        match_exclude: true,
        match_polarity: true,
        match_weight: 0.2,
        options_text: "I wouldn't pay more
$1 - $5
$5 - $10
$10 - $15"
      )

      p.fields.new(
        type: 'CheckboxField',
        title: 'What kind of kind of snack stands should we have?',
        saml_attribute: '',
        gamification_value: 10,
        show_on_vcard: false,
        match_exclude: true,
        match_polarity: true,
        match_weight: 0.2,
        alternative_layout: true, # Select2
        options_text: "Taco
Nacho
Churro
Ice cream
Pizza
Hot Dog"
      )

      p.fields.new(
        type: 'TextField',
        title: 'How could we avoid hispanic stereotypes throughout the park?',
        saml_attribute: '',
        gamification_value: 10,
        show_on_vcard: false,
        match_exclude: true,
        match_polarity: true,
        match_weight: 0.2,
        alternative_layout: true # Multiline
      )

      p.save

      100.times do
        offset = rand(enterprise.users.count)

        r = p.responses.new(
          user: enterprise.users.offset(offset).first
        )

        r[p.fields[0]] = p.fields[0].options[rand(0..p.fields[0].options.count - 1)]
        r[p.fields[1]] = p.fields[1].options[rand(0..p.fields[1].options.count - 1)]
        r[p.fields[2]] = [p.fields[2].options[rand(0..p.fields[2].options.count - 1)]]
        r[p.fields[3]] = Faker::Lorem.paragraph

        r.save
      end

      p.save
    end
    spinner.success("[DONE]")
  end
end
