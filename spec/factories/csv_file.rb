include ActionDispatch::TestProcess

FactoryBot.define do
  factory :csv_file do
    # Paperclip
    # import_file { File.new("#{Rails.root}/spec/fixtures/files/diverst_csv_import.csv") }
    user
  end
end
