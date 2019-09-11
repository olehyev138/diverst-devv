import produce from 'immer';
import eventsReducer from 'containers/Event/reducer';
import {
  getEventSuccess, getEventsSuccess, eventsUnmount
} from 'containers/Event/actions';

describe('eventsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      events: [],
      eventsTotal: null,
      currentEvent: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(eventsReducer(undefined, {})).toEqual(expected)
  });

  it('handles the getEventsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.events = [{ id: 37, name: 'dummy' }];
      draft.eventsTotal = 49;
    });

    expect(
      eventsReducer(
        state,
        getEventsSuccess({
          items: [{ id: 37, name: 'dummy' }],
          total: 49,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getEventSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentEvent = { id: 67, name: 'dummy-2' };
    });

    expect(
      eventsReducer(
        state,
        getEventSuccess({
          initiative: { id: 67, name: 'dummy-2' }
        })
      )
    ).toEqual(expected);
  });

  it('handles the eventsUnmount action correctly', () => {
    const expected = state;

    expect(eventsReducer(state, eventsUnmount())).toEqual(expected);
  });
});
