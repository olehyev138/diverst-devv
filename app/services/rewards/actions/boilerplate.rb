class Rewards::Actions::Boilerplate
  def self.generate
    Enterprise.all.each do |enterprise|
      ["Comments"].each do |action|
        enterprise.reward_actions.create(
          label: action,
          key: action.parameterize.underscore
        )
      end
    end
  end
end
