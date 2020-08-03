import produce from 'immer';
import reducer from '../reducer';
import {
  getUserByTokenBegin, getUserByTokenError, getUserByTokenSuccess,
  submitPasswordBegin, submitPasswordError, submitPasswordSuccess
} from 'containers/User/PasswordResetPage/actions';

describe('reducer', () => {
  let state;
  beforeEach(() => {
    state = {
      token: null,
      isLoading: true,
      isCommitting: false,
      user: null,
      errors: null,
    };
  });

  it('returns the initial state', () => {
    expect(reducer(undefined, {})).toEqual(state);
  });

  it('handles the getUserByTokenBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = true;
    });

    expect(
      reducer(
        state,
        getUserByTokenBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the getUserByTokenError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = false;
    });

    expect(
      reducer(
        state,
        getUserByTokenError({})
      )
    ).toEqual(expected);
  });

  it('handles the getUserByTokenSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isLoading = false;
      draft.user = { id: 5, name: 'Tech Admin' };
      draft.token = 'Hello World';
    });

    expect(
      reducer(
        state,
        getUserByTokenSuccess({
          user: { id: 5, name: 'Tech Admin' },
          token: 'Hello World'
        })
      )
    ).toEqual(expected);
  });

  it('handles the submitPasswordBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
    });

    expect(
      reducer(
        state,
        submitPasswordBegin({})
      )
    ).toEqual(expected);
  });

  [submitPasswordSuccess, submitPasswordError].forEach((action) => {
    it(`handles the ${action.name} action correctly`, () => {
      const expected = produce(state, (draft) => {
        draft.isCommitting = false;
      });

      expect(
        reducer(
          state,
          action({})
        )
      ).toEqual(expected);
    });
  });
});
