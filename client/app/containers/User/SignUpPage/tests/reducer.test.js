import produce from 'immer';
import {
  getUserByTokenSuccess
} from '../actions';
import signUpReducer from '../reducer';

/* eslint-disable default-case, no-param-reassign */
describe('signUpReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      token: null,
      isLoading: true,
      isGroupsLoading: true,
      isCommitting: false,
      user: null,
      groupList: [],
      groupTotal: null,
      errors: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(signUpReducer(undefined, {})).toEqual(expected);
  });

  it('handles the get getUserByTokenSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.token = { id: 4, name: 'dummy' };
      draft.user = {};
      draft.isLoading = false;
    });

    expect(
      signUpReducer(
        state,
        getUserByTokenSuccess({
          token: { id: 4, name: 'dummy' },
          user: {},
          groups: [],
        })
      )
    ).toEqual(expected);
  });
});
