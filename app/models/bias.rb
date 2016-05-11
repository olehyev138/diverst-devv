class Bias < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :groups_from, join_table: 'biases_from_groups', class_name: "Group"
  has_and_belongs_to_many :groups_to, join_table: 'biases_to_groups', class_name: "Group"

  self.table_name = 'biases'
end
