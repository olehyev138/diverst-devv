class Bias < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :groups_from, join_table: 'biases_from_groups', class_name: "Group"
  has_and_belongs_to_many :groups_to, join_table: 'biases_to_groups', class_name: "Group"

  has_and_belongs_to_many :cities_from, join_table: 'biases_from_cities', class_name: 'City'
  has_and_belongs_to_many :cities_to, join_table: 'biases_to_cities', class_name: 'City'

  has_and_belongs_to_many :departments_from, join_table: 'biases_from_departments', class_name: 'Department'
  has_and_belongs_to_many :departments_to, join_table: 'biases_to_departments', class_name: 'Department'

  self.table_name = 'biases'
end
