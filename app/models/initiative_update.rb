class InitiativeUpdate < ActiveRecord::Base
  include ContainsFields

  belongs_to :owner, class_name: "User"
  belongs_to :initiative
end