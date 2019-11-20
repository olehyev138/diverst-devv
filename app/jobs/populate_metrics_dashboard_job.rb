# this is a job that runs nightly to populate the metrics dashboard with dummy data
# it is based off of a clockwork database event that can be disabled and run at specific times

class PopulateMetricsDashboardJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    # check if parameters exist and are valid
    raise BadRequestException.new 'Params missing' if args.blank? || args.class != Hash
    raise BadRequestException.new 'Enterprise ID missing' if args[:enterprise_id].nil?

    # find the enterprise
    enterprise = Enterprise.find_by_id(args[:enterprise_id])
    return if enterprise.nil?

    populate_initiatives(enterprise)
    populate_group_messages(enterprise)
  end

  def populate_initiatives(enterprise)
    return if enterprise.users.count < 1

    user = enterprise.users.first

    numbers = [2, 3, 4, 1, 6, 8, 5, 8, 3, 4, 1, 5]

    enterprise.groups.find_each do |group|
      # create an outcome
      outcome = group.outcomes.create(name: "Test_#{group.id}")
      next if outcome.id.nil?

      # create a pillar
      pillar = outcome.pillars.create(name: "Test_#{outcome.id}", value_proposition: 10)
      next if pillar.id.nil?

      # create initiatives
      numbers.pop.times do
        pillar.initiatives.create(start: Date.yesterday, end: Date.tomorrow, owner_id: user.id, owner_group: group)
      end
    end
  end

  def populate_group_messages(enterprise)
    return if enterprise.users.count < 1

    user = enterprise.users.first

    numbers = [3, 2, 5, 1, 7, 10, 9, 5, 11, 4, 1, 5]

    enterprise.groups.find_each do |group|
      # create initiatives
      numbers.pop.times do
        group.messages.create(subject: "Test_#{Time.now}", content: 'Random Sentence', owner_id: user.id)
      end
    end
  end
end
