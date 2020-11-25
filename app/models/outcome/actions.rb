module Outcome::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [
          :pillars,
          :group,
          pillars: [
              :initiatives,
              initiatives: Initiative.base_preloads(diverst_request) - [:group, group: :user_groups]
          ],
          group: :user_groups
      ]
    end
  end
end
