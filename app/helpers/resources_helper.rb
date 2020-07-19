module ResourcesHelper
  def thumbnail_for_resource(resource)
    return image_url('icons/filetypes/other.png') if resource.file.blank?

    return resource.file.expiring_url(3600) if resource.file_content_type.start_with?('image')

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
      'archive.png'
    else
      # Look for MIME types
      return 'video.png' if res.file_content_type.start_with?('video')

      'other.png'
    end
  end

  def thumbnail_for_answer(answer)
    return answer.supporting_document.url if answer.supporting_document_content_type&.start_with?('image')

    image_url("icons/filetypes/#{thumbnail_for_answer_extension(answer)}")
  end

  def thumbnail_for_answer_extension(res)
    # Try looking for extensions first
    case res.supporting_document_extension.downcase
    when %r{doc}
      'word.png'
    when 'pdf'
      'pdf.png'
    when %r{xlsx?|csv}
      'excel.png'
    when %r{ppt}
      'powerpoint.png'
    when %r{zip|rar|7z|tar|bz2}
      'archive.png'
    else
      # Look for MIME types
      return 'video.png' if res.supporting_document_content_type&.start_with?('video')

      'other.png'
    end
  end

  def get_folders_url(folder, limit = nil, format = nil)
    return if folder.nil?

    if folder.group
      group_folders_path(folder.group, limit: limit, format: :json)
    else
      enterprise_folders_path(folder.enterprise, limit: limit, format: format)
    end
  end
end
