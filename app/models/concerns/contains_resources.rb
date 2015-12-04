module ContainsResources
  extend ActiveSupport::Concern

  included do
    has_many :resources, as: :container
  end
end