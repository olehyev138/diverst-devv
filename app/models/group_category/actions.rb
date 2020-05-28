module GroupCategory::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      [
          'parent_group'
      ]
    end
  end
end
