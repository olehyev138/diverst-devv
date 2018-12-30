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
    end
end