class ColorCode
  def self.theme
    @theme ||= Theme.find(1)
  end

  def self.inverted_primary
    @inverted_primary ||= invert_color_text(theme.branding_color)
  end

  def self.inverted_darken
    @inverted_darken ||= darken(inverted_primary)
  end

  def self.invert_hex_color(rgb)
    inv_rgb = {
      r: 255 - rgb.fetch(:r),
      g: 255 - rgb.fetch(:g),
      b: 255 - rgb.fetch(:b)
    }

    rgb_to_text(inv_rgb)
  end

  def self.invert_hsl_color(hsl, rgb)
    hue = hsl.fetch(:h)
    hsl_inv = [
      { h: (hue + 180) % 360, l: 0.1, s: 0.3 },
      { h: (hue + 180) % 360, l: 0.1, s: 0.9 },
      { h: (hue + 180) % 360, l: 0.9, s: 0.3 },
      { h: (hue + 180) % 360, l: 0.9, s: 0.9 },
    ]

    rgb_inv = hsl_inv.map { |color| hsl_to_rgb(color) }
    rgb_inv.max_by { |color| contrast(color, rgb) }
  end

  def self.rgb_to_hsl(rgb)
    rgb = rgb_i_to_f(rgb)

    min = [rgb.fetch(:r), rgb.fetch(:g), rgb.fetch(:b)].min
    max = [rgb.fetch(:r), rgb.fetch(:g), rgb.fetch(:b)].max

    hsl = {}

    hsl[:l] = (max + min) / 2

    hsl[:s] = min == max ? 0 :  case hsl.fetch(:l)
                                when 0..0.5
                                  (max - min) / (max + min)
                                when 0.5..1
                                  (max - min) / (2.0 - max - min)
                                end

    hsl[:h] = case max
              when rgb[:r]
                (rgb[:g] - rgb[:b]) / (max - min)
              when rgb[:g]
                2.0 + (rgb[:b] - rgb[:r]) / (max - min)
              when rgb[:b]
                4.0 + (rgb[:r] - rgb[:g]) / (max - min)
    end * 60 % 360
    hsl
  end

  def self.hsl_to_rgb(hsl)
    if (sat = hsl.fetch(:s)) == 0
      { r: (sat * 255).round, b: (sat * 255).round, g: (sat * 255).round }
    else
      lum = hsl.fetch(:l)
      hue = hsl.fetch(:h)

      c = (1 - (2 * lum - 1).abs) * sat
      x = c * (1 - (hue / 60 % 2 - 1).abs)
      m = lum - c / 2

      def self.get_color(hue, c, x)
        case hue
        when 0...60
          return c, x, 0
        when 60 ... 120
          return x, c, 0
        when 120 ... 180
          return 0, c, x
        when 180 ... 240
          return 0, x, c
        when 240 ... 300
          return x, 0, c
        when 300 .. 360
          return c, 0, x
        else
          return 0, 0, 0
        end
      end

      red, green, blue = get_color(hue, c, x)

      { r: ((red + m) * 255).round, g: ((green + m) * 255).round, b: ((blue + m) * 255).round }
    end
  end

  def self.contrast(text_rgb, background_rgb)
    text_rgb = rgb_i_to_f(text_rgb)
    text_rgb_prime = {
      R: text_rgb.fetch(:r) < 0.03928 ? text_rgb.fetch(:r) / 12.92 : ((text_rgb.fetch(:r) + 0.055) / 1.055)**2.4,
      G: text_rgb.fetch(:g) < 0.03928 ? text_rgb.fetch(:g) / 12.92 : ((text_rgb.fetch(:g) + 0.055) / 1.055)**2.4,
      B: text_rgb.fetch(:b) < 0.03928 ? text_rgb.fetch(:b) / 12.92 : ((text_rgb.fetch(:b) + 0.055) / 1.055)**2.4
    }

    text_luminescence = 0.2126 * text_rgb_prime.fetch(:R) + 0.7152 * text_rgb_prime.fetch(:G) + 0.0722 * text_rgb_prime.fetch(:B)

    background_rgb = rgb_i_to_f(background_rgb)
    background_rgb_prime = {
      R: background_rgb.fetch(:r) < 0.03928 ? background_rgb.fetch(:r) / 12.92 : ((background_rgb.fetch(:r) + 0.055) / 1.055)**2.4,
      G: background_rgb.fetch(:g) < 0.03928 ? background_rgb.fetch(:g) / 12.92 : ((background_rgb.fetch(:g) + 0.055) / 1.055)**2.4,
      B: background_rgb.fetch(:b) < 0.03928 ? background_rgb.fetch(:b) / 12.92 : ((background_rgb.fetch(:b) + 0.055) / 1.055)**2.4
    }

    background_luminescence = 0.2126 * background_rgb_prime.fetch(:R) + 0.7152 * background_rgb_prime.fetch(:G) + 0.0722 * background_rgb_prime.fetch(:B)

    contrast = (text_luminescence + 0.5) / (background_luminescence + 0.5)

    [contrast, 1 / contrast].max
  end

  def self.text_to_rgb(hex_text)
    if hex_text[0] == '#'
      hex_text = hex_text[1 .. -1]
    end


    integer_color = hex_text.to_i(16)
    rgb = {}
    %w(b g r).inject(integer_color) { |a, i| rest, rgb[i] = a.divmod 256; rest }
    { r: rgb.fetch('r'), g: rgb.fetch('g'), b: rgb.fetch('b') }
  end

  def self.rgb_i_to_f(rgb)
    { r: rgb.fetch(:r).to_f / 255, g: rgb.fetch(:g).to_f / 255, b: rgb.fetch(:b).to_f / 255 }
  end

  def self.test_inverter
    for i in 1..50 do
      background = "##{rand(256**3).to_s(16)}"
      rgbT = invert_color(background)
      rgbB = text_to_rgb(background)

      print("\e[38;2;#{rgbT[:r]};#{rgbT[:g]};#{rgbT[:b]}m")
      print("\e[48;2;#{rgbB[:r]};#{rgbB[:g]};#{rgbB[:b]}mHELLO WORLD")
      print("\e[0m\n")
    end
    print("\e[0mHELLO WORLD\n")
  end

  def self.rgb_to_text(rgb)
    integet = (rgb.fetch(:r) << 16) + (rgb.fetch(:g) << 8) + rgb.fetch(:b)
    to_return = "##{integet.to_s(16)}"
    while to_return.length < 7
      to_return = "#0#{to_return[1..-1]}"
    end
    to_return
  end

  def self.invert_color_text(color, type = 'hsl')
    rgb = invert_color(color, type)
    rgb_to_text(rgb)
  end

  def self.invert_color(color, type = 'hsl')
    rgb = text_to_rgb(color)
    if type == 'rgb'
      invert_hex_color(rgb)
    elsif type == 'hsl'
      hsl = rgb_to_hsl(rgb)
      invert_hsl_color(hsl, rgb)
    else
      { r: 255, b: 255, g: 255 }
    end
  end

  def self.darken(color)
    rgb = text_to_rgb(color)
    hsl = rgb_to_hsl(rgb)
    if hsl[:l] > 0.5
      hsl[:l] -= 0.2
    else
      hsl[:l] += 0.2
    end
    rgb = hsl_to_rgb(hsl)
    rgb_to_text(rgb)
  end
end
