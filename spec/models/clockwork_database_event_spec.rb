require 'rails_helper'

RSpec.describe ClockworkDatabaseEvent, type: :model do
  let(:clockwork_database_event) { build_stubbed(:clockwork_database_event) }

  describe 'validations' do
    it { expect(clockwork_database_event).to validate_presence_of(:name) }
    it { expect(clockwork_database_event).to validate_presence_of(:frequency_quantity) }
    it { expect(clockwork_database_event).to validate_presence_of(:frequency_period) }
    it { expect(clockwork_database_event).to validate_presence_of(:enterprise) }
    it { expect(clockwork_database_event).to validate_presence_of(:job_name) }
    it { expect(clockwork_database_event).to validate_presence_of(:method_name) }

    it { expect(clockwork_database_event).to validate_length_of(:method_args).is_at_most(191) }
    it { expect(clockwork_database_event).to validate_length_of(:method_name).is_at_most(191) }
    it { expect(clockwork_database_event).to validate_length_of(:job_name).is_at_most(191) }
    it { expect(clockwork_database_event).to validate_length_of(:at).is_at_most(191) }
    it { expect(clockwork_database_event).to validate_length_of(:day).is_at_most(191) }
    it { expect(clockwork_database_event).to validate_length_of(:name).is_at_most(191) }

    it { expect(clockwork_database_event).to validate_inclusion_of(:day).in_array(Date::DAYNAMES.map(&:downcase)) }

    it "adds an error when job class doesn't exist" do
      clockwork_database_event = build(:clockwork_database_event, job_name: 'TestClass')
      expect(clockwork_database_event.valid?).to be(false)
      expect(clockwork_database_event.errors.full_messages.first).to eq('Job name uninitialized constant TestClass')
    end

    it "adds an error when job class method doesn't exist" do
      clockwork_database_event = build(:clockwork_database_event, method_name: 'test_method')
      expect(clockwork_database_event.valid?).to be(false)
      expect(clockwork_database_event.errors.full_messages.first).to eq('Method name does not exist')
    end
  end

  describe 'if?' do
    it 'returns false when disabled is true' do
      clockwork_database_event = create(:clockwork_database_event, disabled: true)
      expect(clockwork_database_event.if?).to eq(false)
    end

    it 'returns true when disabled is false' do
      clockwork_database_event = create(:clockwork_database_event, disabled: false)
      expect(clockwork_database_event.if?).to eq(true)
    end

    it 'returns true when disabled is false but at and day are empty strings' do
      clockwork_database_event = create(:clockwork_database_event, disabled: false, day: '', at: '')
      expect(clockwork_database_event.if?).to eq(true)
    end

    it 'returns false when day is monday but current day is saturday' do
      allow(Time).to receive(:now).and_return Time.new(2018, 7, 14)

      clockwork_database_event = create(:clockwork_database_event, disabled: false, day: 'monday')
      expect(clockwork_database_event.if?).to eq(false)
    end

    it 'returns true when day is sunday and current day is sunday' do
      allow(Time).to receive(:now).and_return Time.new(2018, 7, 15, 5, 0, 0)

      clockwork_database_event = create(:clockwork_database_event, disabled: false, day: 'sunday')
      expect(clockwork_database_event.if?).to eq(true)
    end

    it 'returns false when at is 02:02 but current time is 02:03' do
      allow(Time).to receive(:now).and_return Time.new(2002, 10, 31, 2, 3, 0, '-05:00')

      clockwork_database_event = create(:clockwork_database_event, disabled: false, at: '02:02')
      expect(clockwork_database_event.if?).to eq(false)
    end

    it 'returns true when at is 02:02 and current time is 02:02' do
      allow(Time).to receive(:now).and_return Time.new(2002, 10, 31, 2, 2, 0, '-05:00')

      clockwork_database_event = create(:clockwork_database_event, disabled: false, at: '02:02')
      expect(clockwork_database_event.if?).to eq(true)
    end
  end

  describe 'run' do
    it 'calls the job and method correctly' do
      allow(UserGroupNotificationJob).to receive(:perform_later)
      clockwork_database_event = create(:clockwork_database_event)
      clockwork_database_event.run

      expect(UserGroupNotificationJob).to have_received(:perform_later)
    end
  end

  describe '#frequency' do
    it 'returns frequency' do
      expect(clockwork_database_event.frequency).to eq(1.day)
    end
  end

  describe '#formatted_arguments' do
    it 'return nil if methods_args is absent' do
      clockwork_database_event.method_args = nil
      expect(clockwork_database_event.formatted_arguments).to eq(nil)
    end

    it 'returns formated arguments' do
      expect(clockwork_database_event.formatted_arguments).to eq({
        enterprise_id: clockwork_database_event.enterprise_id,
        notifications_frequency: 'weekly'
      })
    end
  end
end
