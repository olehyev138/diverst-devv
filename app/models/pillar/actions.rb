module Pillar::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_select
      ['`pillars`.`id`', '`pillars`.`name`']
    end
  end
end
