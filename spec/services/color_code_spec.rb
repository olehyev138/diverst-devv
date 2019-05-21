require 'rails_helper'

RSpec.describe ColorCode, type: :service do
  before do
    color_values_text = %w(ff cf 7f 30 00)

    @colors_text = []

    color_values_text.each do |r|
      color_values_text.each do |g|
        color_values_text.each do |b|
          @colors_text += ["##{r}#{g}#{b}"]
        end
      end
    end

    color_values_int = [255, 207, 127, 48, 0]

    @colors_rgb = []

    color_values_int.each do |r|
      color_values_int.each do |g|
        color_values_int.each do |b|
          @colors_rgb += [{ r: r, g: g, b: b }]
        end
      end
    end
  end

  it 'Should correctly translate hex text to 8-bit rgb' do
    rgb_translates = @colors_text.map { |x| ColorCode.text_to_rgb(x) }
    for i in 0...@colors_text.length
      expect(rgb_translates[i]).to eql @colors_rgb[i]
    end
  end

  it 'Should correctly translate 8-bit rgb to text' do
    text_tanslates = @colors_rgb.map { |x| ColorCode.rgb_to_text(x) }
    for i in 0...@colors_rgb.length
      expect(text_tanslates[i].downcase).to eql @colors_text[i].downcase
    end
  end

  describe 'hsl translation' do
    before do
      @colors_hsl = @colors_rgb.map { |x| ColorCode.rgb_to_hsl(x) }
    end

    scenario 'Translate and back' do
      rgb2 = @colors_hsl.map { |x| ColorCode.hsl_to_rgb(x) }

      for i in 0...@colors_rgb.length
        expect(rgb2[i]).to eql @colors_rgb[i]
      end
    end

    scenario 'Inverting to RGB = Inverting to text' do
      from_text = @colors_text.map { |x| ColorCode.invert_color_text(x) }
      from_rgb = @colors_text.map { |x| ColorCode.rgb_to_text(ColorCode.invert_color(x)) }

      for i in 0...from_text.length
        expect(from_text[i]).to eql from_rgb[i]
      end
    end

    context 'Inverted' do
      before do
        @inverted_rgb = (@colors_hsl.zip(@colors_rgb)).map { |x, y| ColorCode.invert_hsl_color(x, y) }
        @inverted_hsl = @inverted_rgb.map { |x| ColorCode.rgb_to_hsl(x) }
      end

      scenario 'Inverting hsl' do
        for i in 0...@colors_rgb.length
          expect((@inverted_hsl[i][:h] - @colors_hsl[i][:h]) % 360).to be_within(2.0).of(180.0)
        end
      end

      scenario 'S and L should either be 0.9 or 0.1' do
        @inverted_hsl.each do |hsl|
          expect(hsl[:s]).to be_within(0.05).of(0.3).or be_within(0.05).of(0.9)
          expect(hsl[:l]).to be_within(0.05).of(0.1).or be_within(0.05).of(0.9)
        end
      end

      scenario 'Darkened' do
        darken_rgb = @inverted_rgb.map { |x| ColorCode.darken_rgb(x) }
        darken_hsl = darken_rgb.map { |x| ColorCode.rgb_to_hsl(x) }

        for i in 0...darken_hsl.length
          if @inverted_hsl[i][:l] > 0.5
            expect(darken_hsl[i][:l]).to be_within(0.05).of(0.7)
          else
            expect(darken_hsl[i][:l]).to be_within(0.05).of(0.3)
          end
        end
      end
    end
  end
end
