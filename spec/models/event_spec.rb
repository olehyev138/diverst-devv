require 'rails_helper'

RSpec.describe Event, :type => :model do

    describe 'when validating' do
        let(:event) { FactoryGirl.build_stubbed(:event) }

        it { expect(event).to belong_to(:group) }
        it { expect(event).to belong_to(:owner)}

        it { expect(event).to have_many(:events_segments) }
        it { expect(event).to have_many(:segments).through(:events_segments) }
        it { expect(event).to have_many(:event_attendances) }
        it { expect(event).to have_many(:attendees).through(:event_attendances) }
        it { expect(event).to have_many(:event_invitees) }
        it { expect(event).to have_many(:invitees).through(:event_invitees) }
        it { expect(event).to have_many(:comments) }
        it { expect(event).to have_many(:fields) }
    end

    describe '#time_string' do
        context 'when the event occurs on a single day' do
            it 'prints a well formatted time' do
                event_start = Time.zone.local(2015, 11, 19, 12, 30)
                event_end = Time.zone.local(2015, 11, 19, 14, 30)
                event = build(:event, start: event_start, end: event_end)

                expect(event.time_string).to eq 'November 19, 2015 from 12:30 PM to 2:30 PM'
            end
        end

        context 'when the event spans multiple days' do
            event_start = Time.zone.local(2015, 11, 19, 12, 30)
            event_end = Time.zone.local(2015, 11, 20, 14, 30)
            let(:event) { build(:event, start: event_start, end: event_end) }

            it 'prints a well formatted time' do
                expect(event.time_string).to eq 'From November 19, 2015 at 12:30 PM to November 20, 2015 at 2:30 PM'
            end
        end
    end

    describe 'scopes' do
        let(:past_event) { create(:event, start: Time.zone.local(2015, 11, 9, 12, 30), end: Time.zone.local(2015, 11, 9, 22, 30)) }
        let(:ongoing_event) { create(:event, start: Time.zone.local(2015, 11, 10, 12, 30), end: Time.zone.local(2015, 11, 10, 13, 30)) }
        let(:upcoming_event) { create(:event, start: Time.zone.local(2015, 11, 11, 12, 30), end: Time.zone.local(2015, 11, 11, 13, 30)) }

        before do
            current_time = Time.zone.local(2015, 11, 10, 13, 00)
            allow(Time).to receive(:now).and_return(current_time)
        end

        describe '.past' do
            it 'only include the past event' do
                expect(Event.past).to eq [past_event]
            end
        end

        describe '.ongoing' do
            it 'only include the ongoing event' do
                expect(Event.ongoing).to eq [ongoing_event]
            end
        end

        describe '.upcoming' do
            it 'only include the upcoming event' do
                expect(Event.upcoming).to eq [upcoming_event]
            end
        end
    end

    describe "start/end" do
        it "validates end" do
            event = build(:event, :end => Date.tomorrow)
            expect(event.valid?).to eq(false)
            expect(event.errors.full_messages.first).to eq("End must be after start")
        end
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
            event = create(:event)
            budget = create(:budget, :event => event)
            events_segment = create(:events_segment, :event => event)
            event_attendance = create(:event_attendance, :event => event)
            event_invitee = create(:event_invitee, :event => event)
            event_comment = create(:event_comment, :event => event)
            field = create(:field, :event => event)
            
            event.destroy!
            
            expect{Event.find(event.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Budget.find(budget.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{EventsSegment.find(events_segment.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{EventAttendance.find(event_attendance.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{EventInvitee.find(event_invitee.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{EventComment.find(event_comment.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Field.find(field.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
