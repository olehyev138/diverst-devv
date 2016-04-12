# Update survey responses to match new fields

p.responses.each do |answer|
  p.fields.each do |field|
    if ["SelectField", "CheckboxField"].include?(field.type)
      answer.info[field] = field.options.sample
    else
      answer.info[field] = Faker::Lorem.paragraph
    end

    answer.save
  end
end

# Create dummy answers for campaigns

enterprise = Enterprise.second
campaign = enterprise.campaigns.find(5)
15.times{ campaign.questions.second.answers.create(author: campaign.enterprise.users.sample, content: "Sample answer") }

# Assign random upvotes to those dummy answers

Answer.where(content: "Sample answer").each{|a| (2..10).to_a.sample.times{ a.votes.create(user: enterprise.users.sample) } }

# Add sample events to groups

Enterprise.second.groups.where.not(id: 19).each{|g| (2..6).to_a.sample.times{ g.events.create(title: "Sample event", start: 1.day.from_now, end: 2.days.from_now) } }

# Reset the answer vote counter caches

Answer.find_each { |answer| Answer.reset_counters(answer.id, :votes) }

# Generate feedbacks for topics

Enterprise.second.topics.all.each { |t| (15..54).to_a.sample.times{ t.feedbacks.create(user_id: Enterprise.second.users.ids.sample, content: "Lorem ipsum") } }