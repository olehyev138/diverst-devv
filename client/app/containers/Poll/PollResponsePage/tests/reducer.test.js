import produce from 'immer';
import {
  getQuestionnaireByTokenSuccess
} from '../actions';
import PollResponseReducer from '../reducer';

/* eslint-disable default-case, no-param-reassign */
describe('PollResponseReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      token: null,
      isLoading: true,
      isCommitting: false,
      response: null,
      errors: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(PollResponseReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getPollsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.token = { id: 4, name: 'dummy' };
      draft.response = {};
      draft.isLoading = false;
    });

    expect(
      PollResponseReducer(
        state,
        getQuestionnaireByTokenSuccess({
          token: { id: 4, name: 'dummy' },
          response: {},
        })
      )
    ).toEqual(expected);
  });
});
