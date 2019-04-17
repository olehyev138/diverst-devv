after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating enterprise with campaigns...", format: :spin_2)
  spinner.run do |spinner|
    enterprise = Enterprise.find_by_name "Diverst Inc"
    10.times do
      campaign = enterprise.campaigns.new(title: Faker::Lorem.sentence,
                                          description: Faker::Lorem.paragraph,
                                          nb_invites: 10,
                                          start: DateTime.now >> 2,
                                          end: DateTime.now >> 5,
                                          status: 0,
                                          owner_id: enterprise.users.sample.id)
      campaign.groups << enterprise.groups.sample
      campaign.save
    end
    spinner.success("[DONE]")
  end
end