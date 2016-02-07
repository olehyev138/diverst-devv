10.times do |i|
  g = Enterprise.first.groups.new(
    name: Faker::Commerce.color.capitalize,
    description: Faker::Lorem.sentence
  )

  User.all.each do |user|
    g.members << user if rand(100) < 25
  end

  if g.save
    puts "Group ##{i + 1} created successfully."
  else
    puts "Error(s) saving group ##{i + 1}: "
    puts g.errors.messages
  end
end
