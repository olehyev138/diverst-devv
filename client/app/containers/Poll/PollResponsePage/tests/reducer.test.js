import produce from 'immer';
import {
  getQuestionnaireByTokenSuccess
} from '../actions';
import signUpReducer from '../reducer';

/* eslint-disable default-case, no-param-reassign */
describe('signUpReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      token: null,
      isLoading: true,
      isCommitting: false,
      response: null,
      errors: null,
      groups: []
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(signUpReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getPollsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.token = { id: 4, name: 'dummy' };
      draft.response = {};
      draft.isLoading = false;
    });

    expect(
      signUpReducer(
        state,
        getQuestionnaireByTokenSuccess({
          token: { id: 4, name: 'dummy' },
          response: {},
        })
      )
    ).toEqual(expected);
  });
});
