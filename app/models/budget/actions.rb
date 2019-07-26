require 'base64'
require 'rqrcode'

module Budget::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def build(diverst_request, params)
      item = super
      annual_budget = diverst_request.user.enterprise.annual_budgets.find_or_create_by(closed: false, group_id: item.group_id)
      item.annual_budget_id = annual_budget.id
      item.save!

      item
    end
  end
end
