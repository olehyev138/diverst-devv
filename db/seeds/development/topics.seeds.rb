spinner = TTY::Spinner.new(":spinner Populating enterprises with topics...", format: :spin_2)
spinner.run do |spinner|
	10.times do |_i|
	  Enterprise.all.each do |enterprise|		
	  	enterprise.topics.create(
	    	statement: Faker::Lorem.sentence,
	    	expiration: 1.month.from_now
	  	)
	  end
  end
  spinner.success("[DONE]")
end
