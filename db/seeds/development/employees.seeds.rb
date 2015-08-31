nb_employees = 200

enterprise = Enterprise.first
domain_name = enterprise.name.parameterize + ".com"
first_name_field = TextField.where(title: "First name").first
last_name_field = TextField.where(title: "Last name").first
gender_field = SelectField.where(title: "Gender").first
age_field = NumericField.where(title: "Age").first
disabilities_field = SelectField.where(title: "Disabilities?").first
title_field = TextField.where(title: "Current title").first

other_fields = [
  nationality_field = SelectField.where(title: "Nationality").first,
  belief_field = SelectField.where(title: "Belief").first,
  languages_field = CheckboxField.where(title: "Spoken languages").first,
  ethnicity_field = SelectField.where(title: "Ethnicity").first,
  kids_field = SelectField.where(title: "Status").first,
  orientation_field = SelectField.where(title: "LGBT?").first,
  hobbies_field = SelectField.where(title: "Hobbies").first,
  education_field = SelectField.where(title: "Education level").first,
  certifications_field = CheckboxField.where(title: "Certifications").first,
  experience_field = NumericField.where(title: "Experience in your field (in years)").first,
  countries_worked_field = SelectField.where(title: "Countries worked in").first,
  military_field = SelectField.where(title: "Veteran?").first,
  military_field = SelectField.where(title: "Office location").first,
  seniority_field = NumericField.where(title: "Seniority (in years)").first
]

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
  employee.info[title_field] = Faker::Name.title

  # Have a chance to pick a random disability
  if rand(100) < 2
    offset = rand(disabilities_field.options.count)
    employee.info[disabilities_field] = disabilities_field.options.offset(offset).first.title

    # Chance to pick another random disability
    if rand(100) < 2
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

  # Pick random stuff for the rest of the fields
  other_fields.each do |field|
    if field.is_a? NumericField
      employee.info[field] = rand(field.min..field.max)
    elsif field.is_a? SelectField
      offset = rand(field.options.count)
      employee.info[field] = field.options.offset(offset).first.title
    elsif field.is_a? CheckboxField
      if rand(100) < 60
        offset = rand(field.options.count)
        employee.info[field] = [field.options.offset(offset).first.title]

        if rand(100) < 30
          offset = rand(field.options.count)
          employee.info[field] << field.options.offset(offset).first.title
        end
      end
    end
  end

  if employee.save
    puts "Employee ##{i+1} created successfully."
  else
    puts "Error(s) saving employee ##{i+1}: "
    pp(employee.errors.messages)
  end
end