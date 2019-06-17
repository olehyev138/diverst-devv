class PolicyScopeNotFoundException < StandardError
  def initialize
    super('A policy group scope was not found for this model. Ensure that a proper Policy and Scope exist and filter by enterprise')
  end
end
