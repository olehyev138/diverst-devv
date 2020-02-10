class Theme < ApplicationRecord
  has_one :enterprise

  # ActiveStorage
  has_one_attached :logo
  validates :logo, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :logo_paperclip, s3_permissions: 'private'

  validates_length_of :logo_redirect_url, maximum: 191
  validates_length_of :secondary_color, maximum: 191
  validates_length_of :digest, maximum: 191
  validates_length_of :primary_color, maximum: 191

  validates :primary_color, presence: true, format: { with: %r{\A(?:[0-9a-fA-F]{3}){1,2}\z}, message: 'should be a valid hex color' }
  validates :secondary_color, format: { with: %r{\A(?:[0-9a-fA-F]{3}){1,2}\z}, allow_blank: true, message: 'should be a valid hex color' }

  def branding_color
    primary_color
  end

  def charts_color
    return primary_color unless use_secondary_color

    secondary_color || primary_color
  end

  def delete_asset
    return unless digest?

    if Rails.env.production?
      # TODO: Delete old theme files on S3
      # FOG_STORAGE.directories.get(ENV["S3_BUCKET_NAME"]).files.get(asset_path).try(:destroy)
    else
      File.delete(File.join(Rails.root, 'public', asset_path(digest)))
    end
  end

  def asset_path(digest = self.digest)
    "assets/themes/#{asset_name(digest)}.css"
  end

  def asset_name(digest = self.digest)
    "#{id}-#{digest}"
  end

  def asset_url
    if Rails.env.production?
      "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/#{asset_path}"
    else
      "#{ActionController::Base.asset_host}/#{asset_path}"
    end
  end

  def compile
    enterprise_id = enterprise.id
    enterprise.theme_id = nil
    enterprise.save!

    ThemeCompilerJob.perform_later(id, enterprise_id)
  end
end
