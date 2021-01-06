module ApiHelper
  def to_bool(boolean)
    case boolean
    when true, false then boolean
    when String, Symbol then string_to_bool(boolean.to_s)
    else nil
    end
  end

  def string_to_bool(string)
    case string&.downcase
    when nil then nil
    when 'true' then true
    when 'false' then false
    else raise StandardError 'Not a valid boolean. Must be `true`, `false`, of `nil`'
    end
  end
end
