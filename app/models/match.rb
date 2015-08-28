class Match < ActiveRecord::Base
  belongs_to :employee1, class_name: "Employee"
  belongs_to :employee2, class_name: "Employee"

  accepts_nested_attributes_for :employee1, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :employee2, reject_if: :all_blank, allow_destroy: true

  def score
    self.employee1.match_score_with(self.employee2)
  end
end
