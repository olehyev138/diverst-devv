class RefactorElasticsearchJob < ActiveJob::Base
    queue_as :default

    def perform
      ["MentorshipInterest",
        "GroupMessage",
        "Resource",
        "MentoringSession",
        "View",
        "Initiative",
        "Segment",
        "UsersSegment",
        "Group",
        "UserGroup",
        "User",
        "Answer"].each { |g|
        g = g.constantize
        g.__elasticsearch__.delete_index!
        g.__elasticsearch__.create_index!
        g.__elasticsearch__.import batch_size: 100
      }
    end

end
