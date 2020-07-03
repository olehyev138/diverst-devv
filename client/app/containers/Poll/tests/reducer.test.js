import produce from 'immer';
import {
  getPollsSuccess,
  getPollSuccess
} from '../actions';
import pollReducer from 'containers/Poll/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('pollReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      pollList: [],
      pollListTotal: null,
      currentPoll: null,
      isFetchingPolls: true,
      isFetchingPoll: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(pollReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getPollsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.pollList = { id: 4, name: 'dummy' };
      draft.pollListTotal = 31;
      draft.isFetchingPolls = false;
    });

    expect(
      pollReducer(
        state,
        getPollsSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getPollSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentPoll = { id: 4, name: 'dummy' };
      draft.isFetchingPoll = false;
    });

    expect(
      pollReducer(
        state,
        getPollSuccess({
          poll: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
