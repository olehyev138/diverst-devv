module ApplicationHelper
  def is_admin?
    current_admin
  end

  def back_to_diverst_path
    return groups_path if is_admin?
    employee_campaigns_path
  end

  def color_hex_for_extension(ext)
    case ext.downcase
    when /doc/
      '2A5699'
    when 'pdf'
      'C70304'
    when /xls/
      '207245'
    when /ppt/
      'D24625'
    else
      '222'
    end
  end
end
