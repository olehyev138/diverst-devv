10.times do |_i|
  Enterprise.last.topics.create(
    statement: Faker::Lorem.sentence,
    expiration: 1.month.from_now
  )
end
