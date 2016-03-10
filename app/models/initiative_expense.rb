class InitiativeExpense < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :owner, class_name: "User"
end
