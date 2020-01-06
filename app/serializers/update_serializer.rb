class UpdateSerializer < ApplicationRecordSerializer
  attributes :short_comment

  has_many :field_data

  def serialize_all_fields
    true
  end

  def excluded_keys
    [:updatable_type, :updatable_id]
  end

  def short_comment
    out = ''
    object.comments.split(' ').each do |word|
      out += word + ' '
      if out.length > 20
        out.strip
        out += '...'
        break
      end
    end
    out.strip
  end
end
