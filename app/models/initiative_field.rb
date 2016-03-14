class InitiativeField < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :field
end
