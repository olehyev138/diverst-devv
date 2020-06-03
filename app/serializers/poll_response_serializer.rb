class PollResponseSerializer < ApplicationRecordSerializer
  has_many :field_data
  attributes_with_permission :user, if: :not_anonymous?

  def not_anonymous?
    !object&.anonymous
  end

  def serialize_all_fields
    true
  end

  def excluded_keys
    [:user_id]
  end
end
