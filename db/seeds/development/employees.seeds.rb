nb_employees = 200

enterprise = Enterprise.first
domain_name = enterprise.name.parameterize + ".com"
first_name_field = TextField.where(title: "First name").first
last_name_field = TextField.where(title: "Last name").first
gender_field = SelectField.where(title: "Gender").first
age_field = NumericField.where(title: "Age").first
disabilities_field = CheckboxField.where(title: "Disabilities").first

nb_employees.times do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  employee = Employee.create(
    email: Faker::Internet.user_name("#{first_name} #{last_name}", %w(. _ -)) + "@#{domain_name}",
    auth_source: "manual",
    enterprise: enterprise,
    invited_by_id: enterprise.admins.first.id,
    invited_by_type: "Admin",
    invitation_created_at: invite_time = Faker::Time.between(30.days.ago, 3.days.ago),
    invitation_sent_at: invite_time,
    invitation_accepted_at: Faker::Time.between(invite_time, Date.today),
    password: password = SecureRandom.urlsafe_base64,
    password_confirmation: password
  )

  employee.info[age_field] = Faker::Number.between(18, 65)
  employee.info[first_name_field] = first_name
  employee.info[last_name_field] = last_name

  # Have a chance to pick a random disability
  if rand(100) < 5
    offset = rand(disabilities_field.options.count)
    employee.info[disabilities_field] = disabilities_field.options.offset(offset).first.title

    # Chance to pick another random disability
    if rand(100) < 5
      offset = rand(disabilities_field.options.count)
      employee.info[disabilities_field] << disabilities_field.options.offset(offset).first.title
    end
  end

  # Pick gender with a 70-30 repartition
  if rand(100) > 30
    employee.info[gender_field] = "Male"
  else
    employee.info[gender_field] = "Female"
  end

  if employee.save
    puts "Employee ##{i+1} created successfully."
  else
    puts "Error(s) saving employee ##{i+1}: "
    pp(employee.errors.messages)
  end
end