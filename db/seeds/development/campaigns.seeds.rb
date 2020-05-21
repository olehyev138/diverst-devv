after 'development:groups' do
  campaigns_content = [
    {
      title: "Ideas for ending food waste",
      description: "The United Nations’ Food and Agriculture Organization (FAO) estimates the world produces enough food waste — about 1.4 billion tons, to feed 2 billion people annually. We are asking all associates for your best ideas to combat this this wasteful trend and help do our part to feed more people globally.",
      questions: [
        {
          title: "What can we do internally to help prevent food waste?",
          description: "There are things we could improve on every day, small things that add-up to big numbers. Let's do our part as good corporate citizen and a well-managed company.",
          answers: [
            {
              content: "I think a great way to prevent food waste at our office locations is to donate our cafeteria leftovers to the homeless.",
              comments: [
                {
                  content: "I agree with this!"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      title: "We want to improve our programs geared towards women",
      description: "Please share your best practices involving women's programs or initiatives. Through diverse crowdsourcing we will develop the most innovative solution.",
      questions: [
        {
          title: "What sort of programs intended for women would you like to see?",
          description: "We can support women more by utilizing programs created for women.",
          answers: []
        }
      ]
    },
    {
      title: "Improving work-life balance",
      description: "Our employees are a crucial part of our success and we need to come up with a way to improve their work-life balance.",
      questions: [
        {
          title: "How can we adjust in order to provide a healthier work-life balance?",
          description: "We want to make our employees happy in their job to improve quality of work.",
          answers: [
            {
              content: "I think we should add on-site child care to every office location, it would be perfect for parents!",
              comments: [
                {
                  content: "This is a great idea. I have kids of my own and I have to drive them to our daycare in traffic before work every day."
                }
              ]
            },
            {
              content: "If we worked on a flex schedule we could potentially avoid traffic or work more hours to earn a little bit of time off",
              comments: [
                {
                  content: "I would love to earn a day off every once in a while by working slightly more everyday."
                },
                {
                  content: "With it I wouldn't have to head to the gym so early in the morning!"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      title: "How can we improve our talent acquisition efforts to hire veterans from the African American community?",
      description: "Through crowdsourcing of our wonderful ERGs, we want to hear your amazing ideas on how we can accomplish this lofty goal.",
      questions: []
    }
  ]

  spinner = TTY::Spinner.new(":spinner Populating enterprises with campaigns...", format: :spin_2)
  spinner.run do |spinner|
    enterprise = Enterprise.where(name: "Diverst Inc").first
    campaigns_content.each do |campaign_content|
      start_date = Faker::Time.between(enterprise.created_at + 1.day, Time.current - 2.days)
      end_date = Faker::Time.between(start_date + 1.day, start_date + 12.days)

      campaign = enterprise.campaigns.new(title: campaign_content[:title],
                                          description: campaign_content[:description],
                                          nb_invites: rand(7..20),
                                          created_at: start_date - 1.day,
                                          start: start_date,
                                          end: end_date,
                                          status: rand(100) > 5 ? Campaign.statuses[:published] : Campaign.statuses[:draft],
                                          owner_id: enterprise.users.sample.id)

      campaign.groups << enterprise.groups.sample(rand(1..5))
      campaign.save(validate: false) # To prevent "Start must be after today" validation

      # Create questions
      campaign_content[:questions].each do |question_content|
        question = campaign.questions.create(title: question_content[:title], description: question_content[:description],
                                             created_at: Faker::Time.between(campaign.created_at, Time.current - 2.days))

        # Create answers
        question_content[:answers].each do |answer_content|
          contributing_group = campaign.groups.sample
          author = contributing_group.members.sample

          answer = question.answers.create(content: answer_content[:content], contributing_group: contributing_group, author: author,
                                           created_at: Faker::Time.between(question.created_at, Time.current - 1.day))

          # Create answer votes
          (0..rand(0..11)).each do |i|
            voting_user = campaign.groups.sample.members.sample
            answer.votes.create(author_id: voting_user.id, answer_id: answer.id,
                                created_at: Faker::Time.between(answer.created_at, Time.current)) if answer.votes.find_by(author_id: voting_user.id).nil?
          end

          # Create answer comments
          answer_content[:comments].each do |comment_content|
            commenter = campaign.groups.sample.members.where("users.id != ?", author.id).sample

            answer.comments.create(content: comment_content[:content], author: commenter,
                                   created_at: Faker::Time.between(answer.created_at, Time.current))
          end
        end
      end
    end

    # Bad enterprise data generation
    start_date = Faker::Time.between(1.year.ago, Time.current - 2.days)
    end_date = Faker::Time.between(start_date + 1.day, start_date + 12.days)

    bad_enterprise = Enterprise.where(name: "BAD ENTERPRISE").first
    campaign = bad_enterprise.campaigns.new(title: "BAD CAMPAIGN",
                                            description: "NOT GOOD",
                                            nb_invites: rand(7..20),
                                            created_at: start_date,
                                            start: start_date,
                                            end: end_date,
                                            status: rand(100) > 5 ? Campaign.statuses[:published] : Campaign.statuses[:draft],
                                            owner_id: bad_enterprise.users.sample.id)

    campaign.groups << bad_enterprise.groups.sample(rand(1..5))
    campaign.save

    spinner.success("[DONE]")
  end
end