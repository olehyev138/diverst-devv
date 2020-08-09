class SuggestedHirePolicy < GroupBasePolicy
  def create?
    return true if record === user

    super
  end
end