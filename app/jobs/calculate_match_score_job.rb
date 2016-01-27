class CalculateMatchScoreJob < ActiveJob::Base
  queue_as :low

  def perform(employee, other_employee, skip_existing: false)
    if (existing_match = Match.between(employee, other_employee).first)
      if skip_existing
        logger.info 'Skipping existing match'
      else
        logger.info "Updating existing match between employees #{employee.id} and #{other_employee.id}"
        existing_match.update_score
        existing_match.save!
      end
    else
      logger.info "Creating new match between employees #{employee.id} and #{other_employee.id}"
      Match.create(
        user1: employee,
        user2: other_employee
      )
    end
  end
end
