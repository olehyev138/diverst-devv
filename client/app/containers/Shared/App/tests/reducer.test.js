import produce from 'immer/dist/immer';

import appReducer from 'containers/Shared/App/reducer';
import {
  loginSuccess,
  logoutSuccess,
  setUserData,
  findEnterpriseError,
  fetchUserDataBegin,
  fetchUserDataSuccess,
  fetchUserDataError,
  toggleAdminDrawer
}
  from 'containers/Shared/App/actions';

/* eslint-disable default-case, no-param-reassign */
describe('appReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      token: null,
      data: null,
      findEnterpriseError: false,
      isFetchingUserData: true,
      fetchUserDataError: false,
      adminDrawerOpen: false,
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

  it('handles the findEnterpriseError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.findEnterpriseError = true;
    });

    expect(appReducer(state, findEnterpriseError())).toEqual(expected);
  });

  it('handles the fetchUserDataBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingUserData = true;
      draft.fetchUserDataError = false;
    });

    expect(appReducer(state, fetchUserDataBegin())).toEqual(expected);
  });

  it('handles the fetchUserDataSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingUserData = false;
    });

    expect(appReducer(state, fetchUserDataSuccess())).toEqual(expected);
  });

  it('handles the fetchUserDataError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingUserData = false;
      draft.fetchUserDataError = true;
    });

    expect(appReducer(state, fetchUserDataError())).toEqual(expected);
  });

  it('handles the toggleAdminDrawer action correctly with no argument', () => {
    const expected = produce(state, (draft) => {
      draft.adminDrawerOpen = true;
    });

    expect(appReducer(state, toggleAdminDrawer())).toEqual(expected);
  });

  it('handles the toggleAdminDrawer action correctly with an argument', () => {
    const expected = produce(state, (draft) => {
      draft.adminDrawerOpen = false;
    });

    expect(appReducer(state, toggleAdminDrawer(false))).toEqual(expected);
  });
});
