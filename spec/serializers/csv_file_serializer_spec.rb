require 'rails_helper'

RSpec.describe CsvFileSerializer, type: :serializer do
  it 'returns csv file' do
    csv_file = create(:csv_file)
    serializer = CsvFileSerializer.new(csv_file, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq csv_file.id
    expect(serializer.serializable_hash[:import_file]).to_not be nil
    expect(serializer.serializable_hash[:import_file_file_name]).to_not be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
