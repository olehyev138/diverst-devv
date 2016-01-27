10.times do |_i|
  Enterprise.first.topics.create(
    admin: Enterprise.first.admins.first,
    statement: Faker::Lorem.sentence,
    expiration: 1.month.from_now
  )
end
