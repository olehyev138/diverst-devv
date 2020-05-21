after 'development:users' do
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
        # Create mentorship profiles
        enterprise.users.each do |user|
          if rand(3) < 2 # Have a chance to not make mentorship profile for a user
            days_of_the_week.shuffle!
            rand(1..3).times do |i| # Create mentorship availabilities
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

        mentor_enabled_users = enterprise.users.mentors
        mentee_enabled_users = enterprise.users.mentees

        # Create Mentorings
        mentor_enabled_users.each do |mentor|
          mentees_list = mentee_enabled_users.where.not(id: mentor.id).to_a.shuffle
          rand(0..(mentees_list.count > 8 ? 8 : mentees_list.count)).times do |i|
            mentee = mentees_list[i]
            created_at = Faker::Time.between(mentor.created_at > mentee.created_at ? mentor.created_at : mentee.created_at, Date.today - 2.days)
            Mentoring.create!(mentor_id: mentor.id, mentee_id: mentee.id, created_at: created_at) if rand(5) < 4
          end
        end

        mentors = Mentoring.all.map(&:mentor).uniq
        # Create mentoring sessions
        rand(2..5).times do |i|
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

          mentees = Mentoring.where(mentor_id: creator.id).map(&:mentee).uniq.shuffle
          # Create mentorship sessions
          rand((mentees.count > 1 ? 1 : 0)..(mentees.count > 4 ? 4 : mentees.count)).times do |j|
            status = case rand(7)
            when 0..4
              "accepted"
            when 5
              "declined"
            else
              "pending"
            end
            mentoring_session.mentorship_sessions.create!(user_id: mentees[j].id, status: status, role: "viewer")
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end