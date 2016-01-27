10.times do |i|
  g = Enterprise.first.groups.new(
    name: Faker::Commerce.color.capitalize,
    description: Faker::Lorem.sentence
  )

  Employee.all.each do |employee|
    g.members << employee if rand(100) < 25
  end

  if g.save
    logger.info "Group ##{i + 1} created successfully."
  else
    logger.info "Error(s) saving group ##{i + 1}: "
    logger.info g.errors.messages
  end
end
