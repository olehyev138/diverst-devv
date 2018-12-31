after 'development:enterprise' do
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
            user = enterprise.users.where(user_role_id: 7).first
            FactoryGirl.create_list(:mentoring_session, rand(5..10), enterprise_id: enterprise.id, creator_id: admin.id )

            FactoryGirl.create(:mentoring_request, enterprise_id: enterprise.id, sender_id: user.id, receiver_id: admin.id )
        end
    end
end