module MetricsDashboard::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def build(diverst_request, params)
      item = super
      item.owner_id = diverst_request.user.id
      item.save!

      item
    end
  end
end
