RSpec.describe Event do
  describe "#time_string" do
    context "when the event occurs on a single day" do
      it "prints a well formatted time" do
        event_start = DateTime.new(2015, 11, 19, 12, 30)
        event_end = DateTime.new(2015, 11, 19, 14, 30)
        event = build(:event, start: event_start, end: event_end)

        expect(event.time_string).to eq "November 19, 2015 from 12:30 PM to 2:30 PM"
      end
    end

    context "when the event spans multiple days" do
      event_start = DateTime.new(2015, 11, 19, 12, 30)
      event_end = DateTime.new(2015, 11, 20, 14, 30)
      let(:event) { build(:event, start: event_start, end: event_end) }

      it "prints a well formatted time" do
        expect(event.time_string).to eq "From November 19, 2015 at 12:30 PM to November 20, 2015 at 2:30 PM"
      end
    end
  end

  describe "scopes" do
    let(:past_event) { create(:event, start: DateTime.new(2015, 11, 9, 12, 30), end: DateTime.new(2015, 11, 9, 2, 30)) }
    let(:ongoing_event) { create(:event, start: DateTime.new(2015, 11, 10, 12, 30), end: DateTime.new(2015, 11, 10, 13, 30)) }
    let(:upcoming_event) { create(:event, start: DateTime.new(2015, 11, 11, 12, 30), end: DateTime.new(2015, 11, 11, 13, 30)) }

    before do
      current_datetime = DateTime.new(2015, 11, 10, 13, 00)
      allow(DateTime).to receive(:now).and_return(current_datetime)
    end

    describe ".past" do
      it "only include the past event" do
        expect(Event.past).to eq [past_event]
      end
    end

    describe ".ongoing" do
      it "only include the ongoing event" do
        expect(Event.ongoing).to eq [ongoing_event]
      end
    end

    describe ".upcoming" do
      it "only include the upcoming event" do
        expect(Event.upcoming).to eq [upcoming_event]
      end
    end
  end
end