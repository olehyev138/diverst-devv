after 'development:groups' do
  outcome_titles = [
    'Market Place',
    'Community',
    'Commercial Impact',
    'Recruiting',
    'Leadership Development'
  ]

  pillar_titles = [
    'Grow Market Share',
    'Community Outreach',
    'Marketing for Diversity & Customer Involvement',
    'Production Innovation',
    'Philanthropy, Outreach and Volunteering',
    'Fundraising and community volunteer opportunities'
  ]

  initiative_titles = [
    'International Womens Day',
    'Breast Cancer Awareness Event',
    'Mentorship Network Session',
    'Networking Workshop',
    'Tech Leadership of Tomorrow',
    'Juneteenth African American Business Awards Luncheon',
    'MBA Professional Development Program',
    'Lean In Circle',
    'Leadership Skills Series',
    'Management Leaders of Tomorrow',
    'Black History Month Kick Off',
    'National Save For Retirement Week',
    'Happy Lunar New Year',
    'NYC Pride Day',
    'Out Professionals Employee Network',
    'Latino Heritage Month Los Angles',
    'Effectively Guide & Manage ERGs',
    'Speaker Sessions',
    'D&I Potluck',
    'Rock Climbing',
    'Diversity Day'
  ]

  outcomes_range = 1..2
  pillars_range = 1..2
  past_initiatives_range = 2..12
  current_initiatives_range = 1..3
  future_initiatives_range = 1..3

  spinner = TTY::Spinner.new("[:spinner] Populating groups with events...", format: :classic)
  spinner.run('[DONE]') do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        no_outcomes = rand(outcomes_range)
        no_pillars = rand(pillars_range)
        no_past_initiatives = rand(past_initiatives_range)
        no_current_initiatives = rand(current_initiatives_range)
        no_future_initiatives = rand(future_initiatives_range)

        outcome_titles.shuffle.slice(0..no_outcomes).each { |outcome_title|
          outcome = Outcome.create!(group_id: group.id,
                                    created_at: Faker::Time.between(2.years.ago, Time.current - 2.days),
                                    name: outcome_title)
          pillar_titles.shuffle.slice(0..no_pillars).each { |pillar_title|
            pillar = Pillar.create!(outcome_id: outcome.id,
                                    created_at: Faker::Time.between(2.years.ago, Time.current - 2.days),
                                    name: pillar_title)
            # past initiatives
            initiative_titles.shuffle.slice(0..no_past_initiatives).each { |initiative_title|
              start_date = Faker::Time.between(2.years.ago, Time.current - 2.weeks)
              end_date = Faker::Time.between(start_date + 1.day, start_date + rand(2..9).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title)
            }

            # current initiatives
            initiative_titles.shuffle.slice(0..no_current_initiatives).each { |initiative_title|
              start_date = Faker::Time.between(rand(2..4).days.ago, Time.current - 1.days)
              end_date = Faker::Time.between(Time.current + 1.day, Time.current + rand(2..9).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title)
            }

            # future initiatives
            initiative_titles.shuffle.slice(0..no_future_initiatives).each { |initiative_title|
              start_date = Faker::Time.between(Time.current + 1.day, Time.current + rand(2..9).days)
              end_date = Faker::Time.between(start_date + 1.day, start_date + rand(2..9).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title)
            }
          }
        }
      end
    end
  end
end