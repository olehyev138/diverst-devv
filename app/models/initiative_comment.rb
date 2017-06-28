class InitiativeComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :initiative

  def group
    initiative.group
  end
end
