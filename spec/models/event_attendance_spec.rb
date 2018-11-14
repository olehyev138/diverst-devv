require 'rails_helper'

RSpec.describe EventAttendance, type: :model do
  
  let(:event_attendance) { build(:event_attendance) }

  it { expect(event_attendance).to belong_to :event }
  it { expect(event_attendance).to belong_to :user }
end
