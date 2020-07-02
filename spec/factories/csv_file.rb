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

    factory :csv_file_download do
      user
      download_file_name { 'test' }

      transient do
        download_file_file { Pathname.new("#{Rails.root}/spec/fixtures/files/diverst_csv_download.csv") }
        after(:build) do |csv_file_download, evaluator|
          if csv_file_download.import_file.attached?
            csv_file_download.import_file.detach
          end
          csv_file_download.download_file.attach(
            io: evaluator.download_file_file.open,
            filename: evaluator.download_file_file.basename.to_s
          )
        end
      end
    end
  end
end
