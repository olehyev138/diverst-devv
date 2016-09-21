after :enterprise do
  puts "Importing users"
  nb_users = ENV["NB_USERS"].to_i || 100

  enterprise = Enterprise.last
  domain_name = enterprise.name.parameterize + '.com'
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

  policy_group = enterprise.policy_groups.create(
    name: "Superadmins",

    campaigns_index: true,
    campaigns_create: true,
    campaigns_manage: true,

    polls_index: true,
    polls_create: true,
    polls_manage: true,

    events_index: true,
    events_create: true,
    events_manage: true,

    group_messages_index: true,
    group_messages_create: true,
    group_messages_manage: true,

    groups_index: true,
    groups_create: true,
    groups_manage: true,
    groups_members_index: true,
    groups_members_manage: true,

    metrics_dashboards_index: true,
    metrics_dashboards_create: true,

    news_links_index: true,
    news_links_create: true,
    news_links_manage: true,

    enterprise_resources_index: true,
    enterprise_resources_create: true,
    enterprise_resources_manage: true,

    segments_index: true,
    segments_create: true,
    segments_manage: true,

    users_index: true,
    users_manage: true,

    initiatives_index: true,
    initiatives_create: true,
    initiatives_manage: true,

    global_settings_manage: true,
    admin_pages_view: true
  )

  # Create our own users
  u1 = enterprise.users.create(
    email: "frank@#{domain_name}",
    first_name: 'Francis',
    last_name: 'Marineau',
    password: 'password',
    password_confirmation: 'password',
    policy_group: policy_group,
    invitation_accepted_at: Faker::Time.between(3.days.ago, Time.current)
  )

  u2 = enterprise.users.create(
    email: "andre@#{domain_name}",
    first_name: 'André',
    last_name: 'Laurin',
    password: 'password',
    password_confirmation: 'password',
    policy_group: policy_group,
    invitation_accepted_at: Faker::Time.between(3.days.ago, Time.current)
  )

  u3 = enterprise.users.create(
    email: "ryan@#{domain_name}",
    first_name: 'Ryan',
    last_name: 'Dankoff',
    password: 'password',
    password_confirmation: 'password',
    policy_group: policy_group,
    invitation_accepted_at: Faker::Time.between(3.days.ago, Time.current)
  )

  users_to_create = []

  # Populate generic users
  nb_users.times do |i|
    user = enterprise.users.new(
      first_name: first_name = Faker::Name.first_name,
      last_name: last_name = Faker::Name.last_name,
      email: Faker::Internet.user_name("#{first_name} #{last_name}", %w(. _ -)) + "@#{domain_name}",
      job_title: Faker::Name.title,
      auth_source: 'manual',
      invited_by_id: u1.id,
      invitation_created_at: invite_time = Faker::Time.between(30.days.ago, 3.days.ago),
      invitation_sent_at: invite_time,
      invitation_accepted_at: Faker::Time.between(invite_time, Time.zone.today),
      password: password = SecureRandom.urlsafe_base64,
      password_confirmation: password,
      policy_group: policy_group
    )

    users_to_create << user
  end

  User.import users_to_create

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
