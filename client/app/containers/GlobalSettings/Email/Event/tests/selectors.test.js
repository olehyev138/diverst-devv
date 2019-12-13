import {
  selectEventDomain,
  selectPaginatedEvents,
  selectEventsTotal,
  selectEvent,
  selectFormEvent,
  selectIsFetchingEvents,
  selectIsFetchingEvent,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

describe('Event selectors', () => {
  describe('selectEventDomain', () => {
    it('should select the event domain', () => {
      const mockedState = { mailEvents: { mailEvent: {} } };
      const selected = selectEventDomain(mockedState);

      expect(selected).toEqual({ mailEvent: {} });
    });
  });

  describe('selectPaginatedEvents', () => {
    // TODO: REQUIRES MANUAL IMPLEMENTATION
    it('should select the paginated events', () => {
      const mockedState = {
        eventList: [
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'A',
            at: '00:43',
            day: 'sunday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'B',
            at: '03:43',
            day: 'monday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'B',
            at: '06:43',
            day: 'tuesday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'A',
            at: '09:43',
            day: 'wednesday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'A',
            at: '12:43',
            day: 'thursday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'B',
            at: '15:43',
            day: 'friday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'A',
            at: '18:43',
            day: 'saturday'
          },
          {
            timezones: [['a', 'A'], ['b', 'B']],
            tz: 'A',
            at: '21:43',
            day: ''
          },
        ]
      };

      const expected = [
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'A', value: 'a' },
          at: '00:43',
          at12: '12:43 AM',
          day: { label: 0, value: 'sunday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'B', value: 'b' },
          at: '03:43',
          at12: '3:43 AM',
          day: { label: 1, value: 'monday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'B', value: 'b' },
          at: '06:43',
          at12: '6:43 AM',
          day: { label: 2, value: 'tuesday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'A', value: 'a' },
          at: '09:43',
          at12: '9:43 AM',
          day: { label: 3, value: 'wednesday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'A', value: 'a' },
          at: '12:43',
          at12: '12:43 PM',
          day: { label: 4, value: 'thursday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'B', value: 'b' },
          at: '15:43',
          at12: '3:43 PM',
          day: { label: 5, value: 'friday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'A', value: 'a' },
          at: '18:43',
          at12: '6:43 PM',
          day: { label: 6, value: 'saturday' }
        },
        {
          timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
          tz: { label: 'A', value: 'a' },
          at: '21:43',
          at12: '9:43 PM',
          day: { label: -1, value: '' }
        },
      ];
      const selected = selectPaginatedEvents().resultFunc(mockedState);

      expect(selected).toEqual(expected);
    });
  });

  describe('selectEventsTotal', () => {
    it('should select the events total', () => {
      const mockedState = { eventListTotal: 862 };
      const selected = selectEventsTotal().resultFunc(mockedState);

      expect(selected).toEqual(862);
    });
  });

  describe('selectEvent', () => {
    it('should select the event', () => {
      const mockedState = { currentEvent: { id: 941, __dummy: '941' } };
      const selected = selectEvent().resultFunc(mockedState);

      expect(selected).toEqual({ id: 941, __dummy: '941' });
    });
  });

  describe('selectFormEvent', () => {
    it('should select the form event', () => {
      const mockedState = { currentEvent: {
        timezones: [['a', 'A'], ['b', 'B']],
        tz: 'A',
        at: '00:43',
        day: 'sunday'
      } };
      const selected = selectFormEvent().resultFunc(mockedState);

      expect(selected).toEqual({
        timezones: [{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }],
        tz: { label: 'A', value: 'a' },
        at: '00:43',
        at12: '12:43 AM',
        day: { label: 0, value: 'sunday' }
      });
    });

    it('should return null for null event', () => {
      const mockedState = { currentEvent: null };
      const selected = selectFormEvent().resultFunc(mockedState);

      expect(selected).toEqual(null);
    });
  });

  describe('selectIsFetchingEvents', () => {
    it('should select the \'is fetching events\' flag', () => {
      const mockedState = { isFetchingEvents: false };
      const selected = selectIsFetchingEvents().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsFetchingEvent', () => {
    it('should select the \'is fetching event\' flag', () => {
      const mockedState = { isFetchingEvent: false };
      const selected = selectIsFetchingEvent().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
