FactoryBot.define do
  factory :campaign do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence }
    enterprise
    start Date.today + 1
    self.end Date.today + 7 # We specify self here since end is a reserved keyword
    groups { [create(:group)] }
    factory :campaign_filled do
      transient do
        question_count 2
      end

      after(:create) do |campaign, evaluator|
        create_list(:question_filled, evaluator.question_count, campaign: campaign)
      end
    end
  end
end
