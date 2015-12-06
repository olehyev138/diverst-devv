RSpec.describe Event do
  context "#time_string" do
    it "prints a well formatted time when the event occurs on a single day" do
      event_start = DateTime.new(2015, 11, 19, 12, 30)
      event_end = DateTime.new(2015, 11, 19, 14, 30)
      event = build(:event, start: event_start, end: event_end)

      expect(event.time_string).to eq "November 19, 2015 from 12:30 PM to 2:30 PM"
    end

    it "prints a well formatted time when the event spans multiple days" do
      event_start = DateTime.new(2015, 11, 19, 12, 30)
      event_end = DateTime.new(2015, 11, 20, 14, 30)
      event = build(:event, start: event_start, end: event_end)

      expect(event.time_string).to eq "From November 19, 2015 at 12:30 PM to November 20, 2015 at 2:30 PM"
    end
  end
end