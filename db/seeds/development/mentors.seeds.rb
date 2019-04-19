after 'development:enterprise' do
  spinner = TTY::Spinner.new(":spinner Populating enterprises with mentors...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.mentoring_types.create!([
                                           {name: "Small Group"},
                                           {name: "Individual"},
                                           {name: "Large group"},
                                           {name: "One time"},
                                           {name: "Ongoing"}
                                         ])

      enterprise.mentoring_interests.create!([
                                               {name: "Accounting"},
                                               {name: "Leadership"},
                                               {name: "Problem Solving"},
                                               {name: "Networking"},
                                               {name: "Career Development"},
                                               {name: "People Skills"},
                                               {name: "Public Speaking"}
                                             ])

      days_of_the_week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      if enterprise.name == "Diverst Inc"
        enterprise.users.each do |user|
          if rand(3) < 2 # Have a chance to not make mentorship profile for a user
            days_of_the_week.shuffle!
            (0..rand(1..3)).each do |i| # Create mentorship availabilities
              start_time = Faker::Time.between(Date.today, Date.today, :day)
              end_time = start_time + 2.hours + (rand(0..30)).minutes
              MentorshipAvailability.create!(user_id: user.id, start: start_time.strftime("%-l:%M %p"), end: end_time.strftime("%-l:%M %p"), day: days_of_the_week[i])
            end

            MentorshipInterest.create!(user: user, mentoring_interest: enterprise.mentoring_interests.sample)
            MentorshipType.create!(user: user, mentoring_type: enterprise.mentoring_types.sample)
          end
        end

        # Usually make the user a mentee, sometimes a mentor
        enterprise.users.where(user_role_id: 7).sample(rand(5..12)).map do |user|
          user.update(mentor: rand(100) < 8 ? true : false, mentee: rand(100) > 8 ? true : false)
        end

        # Usually make the admin(s) a mentor, sometimes a mentee
        enterprise.users.where(user_role_id: 1).map do |user|
          user.update(mentor: rand(100) > 8 ? true : false, mentee: rand(100) < 15 ? true : false)
        end

        mentors = enterprise.users.mentors
        mentees = enterprise.users.mentees

        # Create mentoring sessions
        (0..rand(1..5)).each do |i|
          creator = mentors.sample
          start_date = Faker::Time.between(creator.created_at, Date.today, :day)
          end_date = start_date + 2.hours + (rand(0..30)).minutes

          mentoring_session = MentoringSession.new(start: start_date, end: end_date,
                                                   format: "Video",
                                                   enterprise_id: enterprise.id,
                                                   creator_id: creator.id)
          mentoring_session.save(validate: false)

          # Add a mentor topic to the session
          mentoring_session.mentoring_session_topics.create!(mentoring_interest: enterprise.mentoring_interests.sample)

          mentees.where.not(id: creator.id)
          mentees_list = mentees.to_a.shuffle
          # Create mentorship sessions
          (0..rand(2..4)).each do |j|
            status = case rand(7)
            when 0..4
              "accepted"
            when 5
              "declined"
            else
              "pending"
            end
            mentoring_session.mentorship_sessions.create!(user: mentees_list[j], status: status, role: "viewer")
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end