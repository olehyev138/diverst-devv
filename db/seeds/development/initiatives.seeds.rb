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

  past_initiative_titles = [
    'International Womens Day',
    'Breast Cancer Awareness Event',
    'Mentorship Network Session',
    'Networking Workshop',
    'Tech Leadership of Tomorrow',
    'Juneteenth African American Business Awards Luncheon',
    'NYC Pride Day',
    'Out Professionals Employee Network',
    'Latino Heritage Month Los Angles',
    'MBA Professional Development Program',
  ]

  current_initiative_titles = [
    'Management Leaders of Tomorrow',
    'Black History Month Kick Off',
    'National Save For Retirement Week',
    'Lean In Circle',
    'Leadership Skills Series',
  ]

  future_initiative_titles = [
    'Effectively Guide & Manage ERGs',
    'Speaker Sessions',
    'D&I Potluck',
    'Rock Climbing',
    'Diversity Day',
    'Happy Lunar New Year'
  ]

  outcomes_range = 1..1
  pillars_range = 1..2
  past_initiatives_range = 2..5
  current_initiatives_range = 1..2
  future_initiatives_range = 1..3

  spinner = TTY::Spinner.new(":spinner Populating groups with events...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        budget_item_id =
            AnnualBudget.find_by(group_id: group.id, closed: false)
                &.budgets&.order('RAND()')&.first
                &.budget_items&.order('RAND()')&.first&.id
        no_outcomes = rand(outcomes_range)
        no_pillars = rand(pillars_range)
        no_past_initiatives = rand(past_initiatives_range)
        no_current_initiatives = rand(current_initiatives_range)
        no_future_initiatives = rand(future_initiatives_range)

        outcome_titles.shuffle.slice(0..no_outcomes).each { |outcome_title|
          outcome_titles.delete(outcome_title) # delete titles to prevent duplicates
          outcome_title = 'BAD ENTERPRISE ' + outcome_title if enterprise.name != 'Diverst Inc'

          outcome = Outcome.create!(group_id: group.id,
                                    created_at: Faker::Time.between(2.years.ago, Time.current - 2.days),
                                    name: outcome_title)
          pillar_titles.shuffle.slice(0..no_pillars).each { |pillar_title|
            pillar_titles.delete(pillar_title)
            pillar_title = 'BAD ENTERPRISE ' + pillar_title if enterprise.name != 'Diverst Inc'

            pillar = Pillar.create!(outcome_id: outcome.id,
                                    created_at: Faker::Time.between(2.years.ago, Time.current - 2.days),
                                    name: pillar_title)
            # past initiatives
            past_initiative_titles.shuffle.slice(0..no_past_initiatives).each { |initiative_title|
              past_initiative_titles.delete(initiative_title)
              initiative_title = 'BAD ENTERPRISE ' + initiative_title if enterprise.name != 'Diverst Inc'

              start_date = Faker::Time.between(2.years.ago, Time.current - 2.weeks)
              end_date = Faker::Time.between(start_date + 1.day, start_date + rand(2..9).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title, 
                                 budget_item_id: budget_item_id)
            }

            # current initiatives
            current_initiative_titles.shuffle.slice(0..no_current_initiatives).each { |initiative_title|
              current_initiative_titles.delete(initiative_title)
              initiative_title = 'BAD ENTERPRISE ' + initiative_title if enterprise.name != 'Diverst Inc'

              start_date = Faker::Time.between(rand(2..4).days.ago, Time.current - 1.days)
              end_date = Faker::Time.between(Time.current + 1.day, Time.current + rand(2..4).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title,
                                 budget_item_id: budget_item_id)
            }

            # future initiatives
            future_initiative_titles.shuffle.slice(0..no_future_initiatives).each { |initiative_title|
              future_initiative_titles.delete(initiative_title)
              initiative_title = 'BAD ENTERPRISE ' + initiative_title if enterprise.name != 'Diverst Inc'

              start_date = Faker::Time.between(Time.current + 3.day, Time.current + rand(4..9).days)
              end_date = Faker::Time.between(start_date + 1.day, start_date + rand(2..5).days)

              Initiative.create!(pillar_id: pillar.id,
                                 owner_group_id: group.id,
                                 owner_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                 created_at: start_date,
                                 start: start_date,
                                 end: end_date,
                                 name: initiative_title,
                                 budget_item_id: budget_item_id)
            }
          }
        }
      end
    end
    spinner.success("[DONE]")
  end
end