import {
  selectEventsDomain, selectPaginatedEvents,
  selectEventsTotal, selectEvent,
} from 'containers/Event/selectors';

describe('Event selectors', () => {
  describe('selectEventsDomain', () => {
    it('should select the events domain', () => {
      const mockedState = { events: { event: {} } };
      const selected = selectEventsDomain(mockedState);

      expect(selected).toEqual({ event: {} });
    });
  });

  describe('selectPaginatedEvent', () => {
    it('should select the paginared events', () => {
      const mockedState = { events: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedEvents().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectEventsTotal', () => {
    it('should select the group total', () => {
      const mockedState = { eventsTotal: 84 };
      const selected = selectEventsTotal().resultFunc(mockedState);

      expect(selected).toEqual(84);
    });
  });

  describe('selectEvent', () => {
    it('should select the current event', () => {
      const mockedState = { currentEvent: { name: 'dummy-event-02' } };
      const selected = selectEvent().resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-event-02' });
    });
  });
});
