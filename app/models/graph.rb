class Graph < ActiveRecord::Base
  belongs_to :field
  belongs_to :aggregation
end
