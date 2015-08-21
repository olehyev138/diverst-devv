class FieldOption < ActiveRecord::Base
  belongs_to :field

  # 0 to 1. 1 being everybody in the business has chosen this option, 0 being nobody chose it
  def popularity
    enterprise = self.field.enterprise
    nb_employees_chose = 0
    enterprise.employees.each do |employee|
      if employee.info[self.field.id].to_i == self.id
        nb_employees_chose += 1
      end
    end
    nb_employees_chose / enterprise.employees.count
  end
end