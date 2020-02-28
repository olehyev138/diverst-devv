class InitiativeUser < ApplicationRecord
  belongs_to :initiative
  belongs_to :user, counter_cache: :initiatives_count
end
