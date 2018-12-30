10.times do |_i|
  Enterprise.all.each do |enterprise|		
  	enterprise.topics.create(
    	statement: Faker::Lorem.sentence,
    	expiration: 1.month.from_now
  	)
  end
end
