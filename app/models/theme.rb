class Theme < ActiveRecord::Base
  has_one :enterprise

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  after_save :compile, :if => :changed?

  def delete_asset
    return unless digest?

    puts "asset deletion"

    # if Rails.env.production?
    #   FOG_STORAGE.directories.get(ENV['FOG_DIRECTORY']).files.get(asset_path).try(:destroy)
    # else
      File.delete(File.join(Rails.root, 'public', asset_path(digest)))
    # end
  end

  def asset_path(digest = self.digest)
    "assets/themes/#{asset_name(digest)}.css"
  end

  def asset_name(digest = self.digest)
    "#{self.id}-#{digest}"
  end

  def asset_url
    "#{ActionController::Base.asset_host}/#{asset_path}"
  end

  def self.default
    Theme.where(default: true).first
  end

  private

  def compile
    puts "ALLO JE COMPILE UN THEME"
    theme_compiler = ThemeCompiler.new(self)
    theme_compiler.compute
  end
end
