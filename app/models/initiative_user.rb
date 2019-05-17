class InitiativeUser < ApplicationRecord
  belongs_to :initiative
  belongs_to :user
end
