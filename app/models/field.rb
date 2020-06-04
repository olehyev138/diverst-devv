class Field < BaseClass
  belongs_to :enterprise
  belongs_to :group
  belongs_to :poll
  belongs_to :initiative
  has_one :graph, dependent: :destroy

  has_many :yammer_field_mappings, foreign_key: :diverst_field_id, dependent: :delete_all

  validates_length_of :field_type, maximum: 191
  validates_length_of :options_text, maximum: 65535
  validates_length_of :saml_attribute, maximum: 191
  validates_length_of :title, maximum: 191
  validates_length_of :type, maximum: 191
  validates :title, presence: true
  validates :title, uniqueness: { scope: :enterprise_id },
                    unless: :is_segment_or_group_field?, if: :container_type_is_enterprise?

  def container_type_is_enterprise?
    enterprise_id.present?
  end

  def is_segment_or_group_field?
    type == 'SegmentsField' || type == 'GroupsField'
  end

  # The typical field value flow would look like this:
  #   FORM (input string)
  #   1. process_field_value
  #   MEMORY (ruby object)
  #   2. serialize_value
  #   DATABASE (serialized string)
  #   3. deserialize_value
  #   MEMORY (ruby object)
  #   4. string_value
  #   DISPLAY (formatted string)

  # This transforms the user-input value from the form into the desired format
  def process_field_value(value)
    value
  end

  # This serializes the value stored in memory to save it in the DB
  def serialize_value(value)
    value
  end

  # This is called after fetching the raw value stored in the DB.
  def deserialize_value(value)
    value
  end

  # Returns a well-formatted string representing the value. Used for display.
  def string_value(value)
    value
  end

  def csv_value(value)
    value
  end

  def graphable?
    %w(SelectField CheckboxField NumericField).include? type
  end

  def numeric?
    type == 'NumericField' || type == 'DateField'
  end

  def format_value_name(value)
    value
  end

  def enterprise
    return Enterprise.find_by_id(enterprise_id) if enterprise_id.present?
    return group.enterprise if group_id.present?
    return poll.enterprise if poll_id.present?
    return initiative.enterprise if initiative_id.present?
  end
end
