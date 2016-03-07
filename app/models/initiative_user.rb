class InitiativeUser < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :user
end