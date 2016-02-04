module ResourcesHelper
  def thumbnail_for_resource(resource)
    return resource.file.url if resource.file_content_type.start_with?('image/')
    image_url("icons/filetypes/#{file_extension_icon(resource.file_extension)}")
  end

  def file_extension_icon(ext)
    case ext.downcase
    when /doc/
      'word.png'
    when 'pdf'
      'pdf.png'
    when /xls/
      'excel.png'
    when /ppt/
      'powerpoint.png'
    else
      'other.png'
    end
  end

  def can_manage_resources?
    return is_admin? if @container.is_a? Enterprise
    @container.managers.include?(current_user)
  end
end