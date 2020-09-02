require 'rails_helper'

RSpec.describe InitiativeUser::Actions, type: :model do
  describe 'csv_attributes' do
    let(:csv_attributes) {
      [
          'First name',
          'Last name',
          'Email',
          'Attended',
          'Checked In',
          'Check In Time'
      ]
    }

    it { expect(InitiativeUser.csv_attributes.dig(:titles)).to eq csv_attributes }
  end

  describe 'file_name' do
    it 'raises an exception if event id is not valid' do
      expect { InitiativeUser.file_name({}) }.to raise_error(ArgumentError)
    end

    it 'returns file name' do
      event = create(:initiative, name: 'test event name')
      expect(InitiativeUser.file_name({ initiative_id: event.id })).to eq 'Attendees_of_test_event_name'
    end
  end
end
