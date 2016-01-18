class ThemeCompiler
  attr_reader :theme, :body, :tmp_asset_name, :compressed_body, :asset, :env, :tmp_themes_path

  def initialize(theme)
    @theme = theme
    @body = File.read(File.join(Rails.root, 'app', 'assets', 'stylesheets', '_application.scss'))
    @tmp_themes_path = File.join(Rails.root, 'tmp', 'themes')
    @tmp_asset_name = SecureRandom.hex
    @env = if Rails.application.assets.is_a?(Sprockets::Index)
      Rails.application.assets.instance_variable_get('@environment')
    else
      Rails.application.assets
    end
  end

  def compute
    create_temporary_file
    compile
    compress
    upload
    delete_temporary_file
  end

  private

  def create_temporary_file
    FileUtils.mkdir_p(tmp_themes_path) unless File.directory?(tmp_themes_path)
    File.open(File.join(tmp_themes_path, "#{tmp_asset_name}.scss"), 'w') { |f| f.write(body) }
  end

  def compile
    env.context_class.class_exec(theme) do |theme|
      define_method :theme do
        theme
      end
    end

    @asset = env.find_asset(tmp_asset_name)
  end

  def compress
    @compressed_body = ::Sass::Engine.new(asset.source, {
      :syntax => :scss,
      :cache => false,
      :read_cache => false,
      :style => :compressed
    }).render
  end

  def upload
    if Rails.env.production?
      connection = Fog::Storage.new({
        provider: 'AWS',
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      })
      connection.directories.get(ENV['S3_BUCKET_NAME']).files.create(
        key: theme.asset_path(asset.digest),
        body: StringIO.new(compressed_body),
        public: true,
        content_type: 'text/css'
      )
    else
      File.write(File.join(Rails.root, 'public', theme.asset_path(asset.digest)), compressed_body)
    end

    theme.delete_asset
    theme.update_column(:digest, asset.digest)
  end

  def delete_temporary_file
    File.delete(File.join(tmp_themes_path, "#{tmp_asset_name}.scss"))
  end
end
