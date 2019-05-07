class Rewards::Actions::Boilerplate
  def self.generate
    Enterprise.all.each do |enterprise|
      [
        'Attend event',
        'Feedback on event',
        'Campaign answer',
        'Campaign comment',
        'Campaign vote',
        'Survey response',
        'News post',
        'Message post',
        'News comment',
        'Message comment'
      ].each do |action|
        enterprise.reward_actions.create(
          label: action,
          key: action.parameterize.underscore
        )
      end
    end
  end
end
