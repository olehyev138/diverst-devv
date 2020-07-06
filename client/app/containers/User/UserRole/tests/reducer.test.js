import produce from 'immer';
import {
  getUserRolesSuccess,
  getUserRoleSuccess
} from '../actions';
import userRoleReducer from 'containers/User/UserRole/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('userRoleReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isFormLoading: true,
      isCommitting: false,
      userRoleList: {},
      userRoleTotal: null,
      currentUserRole: null,
      isFetchingUserRoles: true,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(userRoleReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getUserRolesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.userRoleList = { 4: { id: 4, name: 'dummy' } };
      draft.userRoleTotal = 31;
      draft.isFetchingUserRoles = false;
    });

    expect(
      userRoleReducer(
        state,
        getUserRolesSuccess({
          items: [{ id: 4, name: 'dummy' }],
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getUserRoleSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentUserRole = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      userRoleReducer(
        state,
        getUserRoleSuccess({
          user_role: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
