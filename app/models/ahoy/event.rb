class Ahoy::Event < ActiveRecord::Base
  serialize :my_json_attribute, ActiveRecord::Type::Json.new
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user
end
