class Rewards::Actions::Boilerplate
  def self.generate
    Enterprise.all.each do |enterprise|
      [
        "Attend event",
        "Feedback on event",
        "Collaborate answer",
        "Collaborate comment",
        "Collaborate vote",
        "Survey response"
      ].each do |action|
        enterprise.reward_actions.create(
          label: action,
          key: action.parameterize.underscore
        )
      end
    end
  end
end
