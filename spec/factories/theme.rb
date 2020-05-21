FactoryBot.define do
  factory :theme do
    primary_color { generate(:hex_color) }
    secondary_color { generate(:hex_color) }

    logo_file_name { 'logo.png' }
    logo_content_type { 'image/png' }
    logo_file_size { 1024 }
  end
end
