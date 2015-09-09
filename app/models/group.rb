class Group < ActiveRecord::Base
  belongs_to :enterprise
  has_many :rules, class_name: "GroupRule"

  def members
    fields = enterprise.fields
    employees = enterprise.includes(:fields).employees.all

    employees.select do |employee|
      employee.is_part_of_group?(group)
    end
  end
end
