10.times do |_i|
  Enterprise.first.topics.create(
    statement: Faker::Lorem.sentence,
    expiration: 1.month.from_now
  )
end
