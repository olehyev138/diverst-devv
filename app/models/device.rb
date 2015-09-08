class Device < ActiveRecord::Base
  @@platform = {
    web: 0,
    ios: 1,
    android: 2
  }.freeze

  def self.platform
    @@status
  end
end
