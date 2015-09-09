class Group < ActiveRecord::Base
  belongs_to :enterprise
  has_many :rules, class_name: "GroupRule"
end
