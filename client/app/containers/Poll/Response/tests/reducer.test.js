import produce from 'immer';
import {
  getResponsesSuccess,
  getResponseSuccess
} from '../actions';
import responseReducer from 'containers/Poll/Response/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('responseReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      responseList: [],
      responseListTotal: null,
      currentResponse: null,
      isFetchingResponses: false,
      isFetchingResponse: false,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(responseReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getResponsesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.responseList = { id: 4, name: 'dummy' };
      draft.responseListTotal = 31;
      draft.isFetchingResponses = false;
    });

    expect(
      responseReducer(
        state,
        getResponsesSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getResponseSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentResponse = { id: 4, name: 'dummy' };
      draft.isFetchingResponse = false;
    });

    expect(
      responseReducer(
        state,
        getResponseSuccess({
          response: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
