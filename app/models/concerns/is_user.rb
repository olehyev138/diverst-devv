module IsUser
  extend ActiveSupport::Concern

  included do
    belongs_to :enterprise, inverse_of: :admins
  end
end