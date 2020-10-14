class InitiativeUserSerializer < ApplicationRecordSerializer
  attributes :user
  attributes_with_permission :initiative, if: :show_action?

  def serialize_all_fields
    true
  end
end
