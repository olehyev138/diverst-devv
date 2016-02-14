after :enterprise do
  nb_users = 10

  enterprise = Enterprise.first
  domain_name = enterprise.name.parameterize + '.com'
  gender_field = SelectField.where(title: 'Gender').first
  birth_field = DateField.where(title: 'Date of birth').first
  disabilities_field = SelectField.where(title: 'Disabilities?').first
  title_field = TextField.where(title: 'Current title').first

  other_fields = [
    SelectField.where(title: 'Nationality').first,
    SelectField.where(title: 'Belief').first,
    CheckboxField.where(title: 'Spoken languages').first,
    SelectField.where(title: 'Ethnicity').first,
    SelectField.where(title: 'Status').first,
    SelectField.where(title: 'LGBT?').first,
    SelectField.where(title: 'Hobbies').first,
    SelectField.where(title: 'Education level').first,
    CheckboxField.where(title: 'Certifications').first,
    NumericField.where(title: 'Experience in your field (in years)').first,
    SelectField.where(title: 'Countries worked in').first,
    SelectField.where(title: 'Veteran?').first,
    SelectField.where(title: 'Office location').first,
    NumericField.where(title: 'Seniority (in years)').first
  ]

  nb_users.times do |i|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name

    user = User.create(
      first_name: first_name,
      last_name: last_name,
      email: Faker::Internet.user_name("#{first_name} #{last_name}", %w(. _ -)) + "@#{domain_name}",
      auth_source: 'manual',
      enterprise: enterprise,
      invited_by_id: enterprise.users.first.id,
      invitation_created_at: invite_time = Faker::Time.between(30.days.ago, 3.days.ago),
      invitation_sent_at: invite_time,
      invitation_accepted_at: Faker::Time.between(invite_time, Time.zone.today),
      password: password = SecureRandom.urlsafe_base64,
      password_confirmation: password
    )

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

    if user.save
      puts "User ##{i + 1} created successfully."
    else
      puts "Error(s) saving user ##{i + 1}: "
    end
  end

  e1 = User.first
  e2 = User.second

  e1.update(email: 'frank@diverst.com', first_name: 'Francis', last_name: 'Marineau', password: 'password', password_confirmation: 'password')
  e2.update(email: 'andre@diverst.com', first_name: "André", last_name: 'Laurin', password: 'password', password_confirmation: 'password')

  e1.info[gender_field] = 'Female'
  e2.info[gender_field] = 'Female'

  e1.save
  e2.save
end