import produce from 'immer/dist/immer';

import loginPageReducer from 'containers/Session/LoginPage/reducer';
import { loginBegin, loginSuccess, loginError } from 'containers/Shared/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('loginPageReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoggingIn: false,
      loginSuccess: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(loginPageReducer(undefined, {})).toEqual(expected);
  });

  it('handles the loginBegin action', () => {
    const expected = produce(state, (draft) => {
      draft.isLoggingIn = true;
      draft.loginSuccess = null;
    });

    expect(loginPageReducer(state, loginBegin())).toEqual(expected);
  });

  it('handles the findEnterpriseError action', () => {
    const expected = produce(state, (draft) => {
      draft.isLoggingIn = false;
      draft.loginSuccess = true;
    });

    expect(loginPageReducer(state, loginSuccess())).toEqual(expected);
  });


  it('handles the loginError action', () => {
    const expected = produce(state, (draft) => {
      draft.isLoggingIn = false;
      draft.loginSuccess = false;
    });

    expect(loginPageReducer(state, loginError())).toEqual(expected);
  });
});
