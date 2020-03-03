import produce from 'immer/dist/immer';

import appReducer from 'containers/Shared/App/reducer';
import {
  loginSuccess,
  loginError,
  logoutSuccess,
  setUserData,
}
  from 'containers/Shared/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('appReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      token: null,
      data: null,
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

  it('handles the setUserData action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.data = { foo: 'bar' };
    });

    expect(appReducer(state, setUserData({ foo: 'bar' }))).toEqual(expected);
  });

  it('handles the setUserData action correctly with the append option', () => {
    state = appReducer(state, setUserData({ foo: 'bar' })); // Set the initial data to append to

    const expected = produce(state, (draft) => {
      draft.data = { foo: 'bar', x: 'y' };
    });

    expect(appReducer(state, setUserData({ x: 'y' }, true))).toEqual(expected);
  });
});
