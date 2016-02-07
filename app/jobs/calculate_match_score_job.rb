class CalculateMatchScoreJob < ActiveJob::Base
  queue_as :low

  def perform(user, other_user, skip_existing: false)
    if (existing_match = Match.between(user, other_user).first)
      if skip_existing
        logger.info 'Skipping existing match'
      else
        logger.info "Updating existing match between users #{user.id} and #{other_user.id}"
        existing_match.update_score
        existing_match.save!
      end
    else
      logger.info "Creating new match between users #{user.id} and #{other_user.id}"
      Match.create(
        user1: user,
        user2: other_user
      )
    end
  end
end
