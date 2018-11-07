require 'rails_helper'

RSpec.describe ThemeCompiler do
  let(:theme) { build(:theme) }
  let(:theme_compiler) { ThemeCompiler.new(theme) }

  before do
    allow(theme).to receive(:id).and_return(123)
    allow(theme).to receive(:update_column) do |column, value|
      theme.digest = value
      true
    end
  end

  it 'creates a css file of the compiled theme' do
    theme_compiler.compute
    expect(File).to exist("#{Rails.root}/public/#{theme.asset_path}")
  end

  it 'deletes the temporary SCSS files' do
    theme_compiler.compute
    expect(File).not_to exist(File.join(theme_compiler.tmp_themes_path, "#{theme_compiler.tmp_asset_name}.scss"))
  end

  it 'deletes the old compiled CSS file if it changed' do
    theme_compiler.compute
    old_asset_path = "#{Rails.root}/public/#{theme.asset_path}"

    # Generate a new color for the theme, making sure we're not using the same one!
    old_color = theme.primary_color
    while old_color == theme.primary_color
      theme.primary_color = '#' + '%06x' % (rand * 0xffffff)
    end

    theme_compiler = ThemeCompiler.new(theme)
    theme_compiler.compute

    expect(File).not_to exist(old_asset_path)
  end

  it 'doesn\'t delete the old compiled CSS if it didn\'t change' do
    theme_compiler.compute
    theme_compiler.compute
    expect(File).to exist("#{Rails.root}/public/#{theme.asset_path}")
  end
end
