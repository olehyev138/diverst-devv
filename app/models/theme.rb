class Theme < ActiveRecord::Base
  has_one :enterprise

  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('missing.png')
  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  validates :primary_color, presence: true, format: { with: %r{\A#(?:[0-9a-fA-F]{3}){1,2}\z}, message: 'should be a valid hex color' }

  before_validation :append_hash_to_colors
  after_save :compile, if: :changed?

  def delete_asset
    return unless digest?

    if Rails.env.production?
      FOG_STORAGE.directories.get(ENV['FOG_DIRECTORY']).files.get(asset_path).try(:destroy)
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
    theme_compiler = ThemeCompiler.new(self)
    theme_compiler.compute
  end

  private

  def append_hash_to_colors
    primary_color.insert(0, '#') if primary_color[0] != '#'
  end
end
