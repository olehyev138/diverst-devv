nb_employees = 200

enterprise = Enterprise.first
age_field = NumericField.where(enterprise: enterprise).first
name_field = TextField.where(enterprise: enterprise).first
disabilities_field = CheckboxField.where(enterprise: enterprise).first
domain_name = enterprise.name.parameterize + ".com"

nb_employees.times do |i|
  employee = Employee.create(
    email: Faker::Internet.user_name(name = Faker::Name.name, %w(. _ -)) + "@#{domain_name}",
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

  invite_time

  employee.info[age_field] = Faker::Number.between(18, 65)
  employee.info[name_field] = name

  # Have a chance to pick a random disability
  if rand(100) < 5
    offset = rand(disabilities_field.options.count)
    employee.info[disabilities_field] = disabilities_field.options.offset(offset).first.id

    # Chance to pick another random disability
    if rand(100) < 5
      offset = rand(disabilities_field.options.count)
      employee.info[disabilities_field] << disabilities_field.options.offset(offset).first.id
    end
  end

  if employee.save
    puts "Employee ##{i+1} created successfully."
  else
    puts "Error(s) saving employee ##{i+1}: "
    pp(employee.errors.messages)
  end
end