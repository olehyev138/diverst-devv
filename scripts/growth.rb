
def rand_time
  from = 1.year.ago
  to = Time.now

  Time.at(from + rand * (to.to_f - from.to_f))
end

User.all.each do |ug|
  ug.created_at = rand_time
  ug.save!
end
