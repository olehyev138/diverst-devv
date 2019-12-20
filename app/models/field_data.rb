class FieldData < ApplicationRecord
  class SameFieldDefinerValidator < ActiveModel::Validator
    def validate(record)
      unless record.field.field_definer_id == record.fieldable.field_holder_id
        record.errors[:field] << 'Field and Fieldable must have same parent'
      end
    end
  end

  belongs_to :fieldable, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :fieldable
  validates_with SameFieldDefinerValidator

  def deserialized_data
    case field.type
    when 'SelectField'
      JSON.parse(data)[0]
    else
      data
    end
  end
end
