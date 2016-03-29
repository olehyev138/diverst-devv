class GroupField < ActiveRecord::Base
  belongs_to :group
  belongs_to :field
end
