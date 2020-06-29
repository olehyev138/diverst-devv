import produce from 'immer';
import {
  getLogsSuccess,
  exportLogsSuccess
} from '../actions';
import logsReducer from 'containers/Log/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('logsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      logList: [],
      logTotal: null,
      isCommitting: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(logsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getLogsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.logList = [{ id: 1, name: 'abc' }];
      draft.logTotal = 44;
      draft.isLoading = false;
    });

    expect(
      logsReducer(
        state,
        getLogsSuccess({
          items: [{ id: 1, name: 'abc' }],
          total: 44,
        })
      )
    ).toEqual(expected);
  });
});
