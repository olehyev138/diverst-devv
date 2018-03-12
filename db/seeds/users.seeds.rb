after :enterprise do
  puts "Importing users"
  
  enterprise = Enterprise.last
  gender_field = enterprise.fields.where(title: 'Gender').first
  birth_field = enterprise.fields.where(title: 'Date of birth').first
  disabilities_field = enterprise.fields.where(title: 'Disabilities?').first
  title_field = enterprise.fields.where(title: 'Current title').first

  other_fields = [
    enterprise.fields.where(title: 'Nationality').first,
    enterprise.fields.where(title: 'Belief').first,
    enterprise.fields.where(title: 'Spoken languages').first,
    enterprise.fields.where(title: 'Ethnicity').first,
    enterprise.fields.where(title: 'Status').first,
    enterprise.fields.where(title: 'LGBT?').first,
    enterprise.fields.where(title: 'Hobbies').first,
    enterprise.fields.where(title: 'Education level').first,
    enterprise.fields.where(title: 'Certifications').first,
    enterprise.fields.where(title: 'Experience in your field (in years)').first,
    enterprise.fields.where(title: 'Countries worked in').first,
    enterprise.fields.where(title: 'Veteran?').first,
    enterprise.fields.where(title: 'Office location').first,
    enterprise.fields.where(title: 'Seniority (in years)').first
  ]

  # create default enterprise user roles
  enterprise.user_roles.create!(
    [
      {:role_name => "admin", :role_type => "user", :priority => 0},
      {:role_name => "diversity_manager", :role_type => "user", :priority => 1},
      {:role_name => "national_manager", :role_type => "user", :priority => 2},
      {:role_name => "group_leader", :role_type => "group", :priority => 3},
      {:role_name => "group_treasurer", :role_type => "group", :priority => 4},
      {:role_name => "group_content_creator", :role_type => "group", :priority => 5},
      {:role_name => "user", :role_type => "user", :priority => 6}
    ]
  )

  enterprise.users.create!(
    [
      {
        email: "tech@diverst.com",
        first_name: 'Tech',
        last_name: 'Admin',
        password: 'password',
        role: "user",
        password_confirmation: 'password',
        invitation_accepted_at: Faker::Time.between(3.days.ago, Time.current)
      }
    ]
  )

  enterprise.users.find_each do |user|

    user.info[title_field] = Faker::Name.title
    user.info[birth_field] = Faker::Date.between(60.years.ago, 18.years.ago)

    # Have a chance to pick a random disability
    if rand(100) < 2
      index = rand(disabilities_field.options.count)
      user.info[disabilities_field] = disabilities_field.options[index]
    end

    # Pick gender with a 70-30 repartition
    user.info[gender_field] = if rand(100) > 30
      'Male'
    else
      'Female'
    end

    # Pick random stuff for the rest of the fields
    other_fields.each do |field|
      if field.is_a? NumericField
        user.info[field] = rand(field.min..field.max)
      elsif field.is_a? SelectField
        index = rand(field.options.count)
        user.info[field] = field.options[index]
      elsif field.is_a? CheckboxField
        if rand(100) < 60
          index = rand(field.options.count)
          user.info[field] = [field.options[index]]

          if rand(100) < 30
            index = rand(field.options.count)
            user.info[field] << field.options[index]
          end
        end
      end
    end

    user.save
  end

  RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
  puts "Importing users [DONE]"
end
