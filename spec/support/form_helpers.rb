module FormHelpers
  def submit_form
    find('input[name="commit"]').click
  end

  def fill_date(selector, date)
    within("div.#{selector}") do
      select date.strftime('%Y'), from: "#{selector}_1i"
      select date.strftime('%B'), from: "#{selector}_2i"
      select date.day.to_s,       from: "#{selector}_3i"
      select date.strftime('%H'), from: "#{selector}_4i"
      select date.strftime('%M'), from: "#{selector}_5i"
    end
  end

  def check_date(selector, date)
    within("div.#{selector}") do
      expect(page).to have_field("#{selector}_1i", with: date.strftime('%Y'))
      expect(page).to have_field("#{selector}_2i", with: date.month.to_s)
      expect(page).to have_field("#{selector}_3i", with: date.day.to_s)
      expect(page).to have_field("#{selector}_4i", with: date.strftime('%H'))
      expect(page).to have_field("#{selector}_5i", with: date.strftime('%M'))
    end
  end

  def test_svg_image_path
    Rails.root + 'spec/fixtures/files/diverst_logo.svg'
  end

  def test_png_image_path
    Rails.root + 'spec/fixtures/files/verizon_logo.png'
  end
end

RSpec.configure do |config|
  config.include FormHelpers, type: :feature
end
