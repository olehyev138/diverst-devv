class PolicyScopeNotFoundException < StandardError
  def initialize
    super('It is likely that a policy scope was not found for this model. Ensure that a proper Policy and Scope exist, and filter if necessary (by enterprise, etc.)')
  end
end
