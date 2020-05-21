def self.set_fields(primary_fields, other_fields, user, gender: rand(2) == 0 ? "Male" : "Female")
  user.policy_group.update_all_permissions(true) if user.user_role.role_name == "Admin"

  user.info[primary_fields[:gender]] = gender

  user.info[primary_fields[:title]] = Faker::Job.title
  user.info[primary_fields[:birth]] = Faker::Date.between(60.years.ago, 18.years.ago)

  # Have a low chance to have a disability
  if rand(100) < 3
    user.info[primary_fields[:disabilities]] = primary_fields[:disabilities].options[0]
  else
    user.info[primary_fields[:disabilities]] = primary_fields[:disabilities].options[1]
  end

  # Pick random stuff for the rest of the fields
  other_fields.each do |field|
    if field.is_a? NumericField
      user.info[field] = rand(field.min..field.max)
    elsif field.is_a? SelectField
      index = rand(field.options.count)
      user.info[field] = field.options[index]
    elsif field.is_a? CheckboxField
      if rand(100) < 50
        index = rand(field.options.count)
        user.info[field] = [field.options[index]]

        # Have a chance to choose check a random 2nd field
        if rand(100) < 30
          second_index = rand(field.options.count)
          user.info[field] = [field.options[index], field.options[second_index]] if second_index != index
        end
      else
        user.info[field] = []
      end
    end
  end

  user.save
end

after 'development:enterprise' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with users...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      primary_fields = {
        gender: enterprise.fields.where(title: 'Gender').first,
        birth: enterprise.fields.where(title: 'Date of birth').first,
        title: enterprise.fields.where(title: 'Current title').first,
        disabilities: enterprise.fields.where(title: 'Disabilities?').first
      }

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
        enterprise.fields.where(title: 'Chapter').first,
        enterprise.fields.where(title: 'Seniority (in years)').first
      ]

      # Create default enterprise user roles
      enterprise.user_roles.create!(
        [
          {:role_name => "Admin", :role_type => "user", :priority => 0},
          {:role_name => "Diversity Manager", :role_type => "user", :priority => 1},
          {:role_name => "National Manager", :role_type => "user", :priority => 2},
          {:role_name => "Group Leader", :role_type => "group", :priority => 3},
          {:role_name => "Group Treasurer", :role_type => "group", :priority => 4},
          {:role_name => "Group Content Creator", :role_type => "group", :priority => 5},
          {:role_name => "User", :role_type => "user", :priority => 6, :default => true}
        ]
      )

      if enterprise.name == "Diverst Inc"
        # Create initial admin user
        admin_user = FactoryBot.create(:user,
                          first_name: "Tech",
                          last_name: "Admin",
                          email: "tech@diverst.com",
                          enterprise: enterprise,
                          password: 'Password!123',
                          password_confirmation: 'Password!123',
                          user_role_id: enterprise.user_roles.find_by_role_name("Admin").id,
                          created_at: 3.days.ago,
                          invitation_accepted_at: 3.days.ago
        )

        set_fields(primary_fields, other_fields, admin_user)

        # Get the user role ID
        user_role_id = enterprise.user_roles.find_by_role_name("User").id

        # Generate users
        (0..rand(500..1000)).each do |i|
          gender = rand(2) == 0 ? "Male" : "Female"
          created_date = Faker::Time.between(enterprise.created_at, Time.current - 2.days)
          password = Faker::String.random(12)

          user = FactoryBot.create(:user,
                                  first_name: gender == "Male" ? Faker::Name.male_first_name : Faker::Name.female_first_name,
                                  last_name: Faker::Name.last_name,
                                  enterprise: enterprise,
                                  password: password,
                                  password_confirmation: password,
                                  user_role_id: user_role_id,
                                  created_at: created_date,
                                  invitation_accepted_at: created_date + 1.day,
                                  active: rand(100) > 2 ? true : false
          )

          set_fields(primary_fields, other_fields, user, gender: gender)
        end
      else
        user_role_id = enterprise.user_roles.find_by_role_name("User").id

        # Generate bad users
        (0..4).each do |i|
          created_date = Faker::Time.between(enterprise.created_at, Time.current - 2.days)
          password = Faker::String.random(12)

          user = FactoryBot.create(:user,
                            first_name: "BAD USER",
                            last_name: "#{i}",
                            email: "baduser#{i}@badenterprise.com",
                            enterprise: enterprise,
                            password: password,
                            password_confirmation: password,
                            user_role_id: user_role_id,
                            created_at: created_date,
                            invitation_accepted_at: created_date + 1.day,
                            active: rand(100) > 2 ? true : false)

          set_fields(primary_fields, other_fields, user)
        end
      end
    end
    spinner.success("[DONE]")
  end
end
