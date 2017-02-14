FactoryGirl.define do
  factory :campaign do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence }
    enterprise
    start Time.zone.local(2015, 11, 10)
    self.end Time.zone.local(2015, 11, 13) # We specify self here since end is a reserved keyword

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
