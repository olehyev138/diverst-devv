module ApiHelper
  def to_bool(string)
    case string&.downcase
    when nil then nil
    when 'true' then true
    when 'false' then false
    else raise StandardError 'Not a valid boolean. Must be `true`, `false`, of `nil`'
    end
  end
end
