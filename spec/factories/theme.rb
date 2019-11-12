FactoryBot.define do
  factory :theme do
    primary_color { generate(:hex_color) }
    secondary_color { generate(:hex_color) }

    transient do
      logo_file { Pathname.new("#{Rails.root}/spec/fixtures/files/verizon_logo.png") }

      after(:build) do |theme, evaluator|
        theme.logo.attach(
          io: evaluator.logo_file.open,
          filename: evaluator.logo_file.basename.to_s
        )
      end
    end
  end
end
