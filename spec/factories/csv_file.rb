include ActionDispatch::TestProcess

FactoryBot.define do
  factory :csv_file do
    user

    transient do
      import_file_file { Pathname.new("#{Rails.root}/spec/fixtures/files/diverst_csv_import.csv") }

      after(:build) do |csv_file, evaluator|
        unless csv_file.import_file.attached?
          csv_file.import_file.attach(
            io: evaluator.import_file_file.open,
            filename: evaluator.import_file_file.basename.to_s
          )
        end
      end
    end
  end
end
