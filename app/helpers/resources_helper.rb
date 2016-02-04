module ResourcesHelper
  def thumbnail_for_resource(resource)
    return resource.file.url if resource.file_content_type.start_with?('image')
    image_url("icons/filetypes/#{thumbnail_for_resource_extension(resource)}")
  end

  def thumbnail_for_resource_extension(res)
    # Try looking for extensions first
    case res.file_extension.downcase
    when %r{doc}
      'word.png'
    when 'pdf'
      'pdf.png'
    when %r{xlsx?|csv}
      'excel.png'
    when %r{ppt}
      'powerpoint.png'
    when %r{zip|rar|7z|tar|bz2}
      return 'archive.png'
    else
      # Look for MIME types
      return 'video.png' if res.file_content_type.start_with?('video')
      'other.png'
    end
  end

  def can_manage_resources?
    return is_admin? if @container.is_a? Enterprise
    @container.managers.include?(current_user)
  end
end