after 'development:enterprise' do
  spinner = TTY::Spinner.new("[:spinner] Importing users...", format: :classic)
  spinner.run('[DONE]') do |spinner|
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
        FactoryBot.create(:user,
                          email: "tech@diverst.com",
                          enterprise: enterprise,
                          password: 'Password!123',
                          password_confirmation: 'Password!123',
                          user_role_id: enterprise.user_roles.find_by_role_name("Admin").id,
                          created_at: 3.days.ago,
                          invitation_accepted_at: 3.days.ago
        )

        user_role_id = enterprise.user_roles.find_by_role_name("User").id

        (0..rand(500..1000)).each do |i|
          created_date = Faker::Time.between(2.years.ago, Time.current - 2.days)
          password = Faker::String.random(12)

          FactoryBot.create(:user,
                            enterprise: enterprise,
                            password: password,
                            password_confirmation: password,
                            user_role_id: user_role_id,
                            created_at: created_date,
                            invitation_accepted_at: created_date + 1.day,
                            active: rand(100) > 2 ? true : false
          )
        end
      else
        user_role_id = enterprise.user_roles.find_by_role_name("User").id

        (0..4).each do |i|
          created_date = Faker::Time.between(1.year.ago, Time.current - 2.days)
          password = Faker::String.random(12)

          FactoryBot.create(:user,
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
        end
      end

      enterprise.users.find_each do |user|

        user.policy_group.update_all_permissions(true) if user.user_role.role_name == "Admin"

        user.info[primary_fields[:title]] = Faker::Job.title
        user.info[primary_fields[:birth]] = Faker::Date.between(60.years.ago, 18.years.ago)

        # Have a chance to pick a random disability
        if rand(100) < 3
          index = rand(primary_fields[:disabilities].options.count)
          user.info[primary_fields[:disabilities]] = primary_fields[:disabilities].options[index]
        end

        # Pick gender with a 50-50 chance
        user.info[primary_fields[:gender]] = if rand(100) > 50
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
    end
  end
end
