import produce from 'immer';
import eventReducer from 'containers/GlobalSettings/Email/Event/reducer';
import {
  getEventBegin, getEventSuccess, getEventError,
  getEventsBegin, getEventsError, getEventsSuccess,
  updateEventBegin, updateEventError, updateEventSuccess,
  eventsUnmount,
} from 'containers/GlobalSettings/Email/Event/actions';

describe('eventReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      eventList: [],
      eventListTotal: null,
      currentEvent: null,
      isFetchingEvents: false,
      isFetchingEvent: false,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('handles the getEventBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEvent = true;
    });

    expect(
      eventReducer(
        state,
        getEventBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the getEventSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentEvent = { id: 30, name: 'dummy30' };
      draft.isFetchingEvent = false;
    });

    expect(
      eventReducer(
        state,
        getEventSuccess({ clockwork_database_event: { id: 30, name: 'dummy30' } })
      )
    ).toEqual(expected);
  });

  it('handles the getEventError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEvent = false;
    });

    expect(
      eventReducer(
        state,
        getEventError({})
      )
    ).toEqual(expected);
  });

  it('handles the getEventsBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEvents = true;
      draft.hasChanged = false;
    });

    expect(
      eventReducer(
        state,
        getEventsBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the getEventsError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEvents = false;
    });

    expect(
      eventReducer(
        state,
        getEventsError({})
      )
    ).toEqual(expected);
  });

  it('handles the getEventsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.eventList = [{ id: 37, name: 'dummy' }];
      draft.eventListTotal = 49;
      draft.isFetchingEvents = false;
    });

    expect(
      eventReducer(
        state,
        getEventsSuccess({
          items: [{ id: 37, name: 'dummy' }],
          total: 49,
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateEventBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
      draft.hasChanged = false;
    });

    expect(
      eventReducer(
        state,
        updateEventBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the updateEventSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.hasChanged = true;
    });

    expect(
      eventReducer(
        state,
        updateEventSuccess({})
      )
    ).toEqual(expected);
  });

  it('handles the updateEventError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      eventReducer(
        state,
        updateEventError({})
      )
    ).toEqual(expected);
  });

  it('handles the eventsUnmount action correctly', () => {
    const expected = {
      eventList: [],
      eventListTotal: null,
      currentEvent: null,
      isFetchingEvents: false,
      isFetchingEvent: false,
      isCommitting: false,
      hasChanged: false,
    };

    expect(
      eventReducer(
        state,
        eventsUnmount({})
      )
    ).toEqual(expected);
  });
});
