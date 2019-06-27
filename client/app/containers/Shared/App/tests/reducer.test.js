import produce from 'immer/dist/immer';

import appReducer from 'containers/Shared/App/reducer';
import {
  loginBegin, loginSuccess, loginError,
  logoutBegin, logoutSuccess, logoutError,
  findEnterpriseBegin, setEnterprise, findEnterpriseError,
  setUser
} from 'containers/Shared/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('appReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      user: null,
      enterprise: null,
      token: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(appReducer(undefined, {})).toEqual(expected);
  });

  it('handles the loginSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.token = 'token';
    });

    expect(appReducer(state, loginSuccess('token'))).toEqual(expected);
  });

  it('handles the logoutSuccess action correctly', () => {
    const tokenState = produce(state, (draft) => {
      draft.token = 'token';
    });

    expect(appReducer(tokenState, logoutSuccess()).token).toBeNull();
  });

  it('handles the setEnterprise action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.enterprise = 'enterprise';
    });

    expect(appReducer(state, setEnterprise('enterprise'))).toEqual(expected);
  });

  it('handles the setUser action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.user = 'user';
    });

    expect(appReducer(state, setUser('user'))).toEqual(expected);
  });
});