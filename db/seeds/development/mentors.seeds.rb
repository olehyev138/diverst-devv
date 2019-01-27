after 'development:enterprise' do
    spinner = TTY::Spinner.new("[:spinner] Populating enterprise with mentors...", format: :classic)
    spinner.run('[DONE]') do |spinner|
        Enterprise.all.each do |enterprise|
            enterprise.mentoring_types.create!([
                {name: "Small Group"},
                {name: "Individual"},
                {name: "Large group"},
                {name: "One time" },
                {name: "Ongoing" }
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
                    MentorshipAvailability.create(user_id: user.id, start: "1:30", end: "2:30", day: days_of_the_week.sample)
                end
                
                admin = enterprise.users.where(user_role_id: 1).first #find first admin in enterprise
                users = enterprise.users.where(user_role_id: 7).limit(5)
                rand(5..10).times { MentoringSession.create(enterprise_id: enterprise.id, creator_id: admin.id ) }

                users.each do |user|
                    MentoringRequest.create(enterprise_id: enterprise.id, sender_id: user.id, receiver_id: admin.id )
                end

                mentees = enterprise.users.where(user_role_id: 7).sample(10).map { |user| user.update(mentee: true, mentor: false); user }
                mentors = enterprise.users.where(user_role_id: 1).map { |user| user.update(mentor: true, mentee: false); user }
            end
        end
    end
end