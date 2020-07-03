import {
  selectUserRoleDomain, selectPaginatedUserRoles,
  selectUserRoleTotal, selectUserRole, selectIsFetchingUserRoles,
  selectIsCommitting, selectIsFormLoading, selectFormUserRole,
  selectPaginatedSelectUserRoles,
} from '../selectors';

import { initialState } from '../reducer';

describe('UserRole selectors', () => {
  describe('selectUserRoleDomain', () => {
    it('should select the userRoles domain', () => {
      const mockedState = { roles: { role: {} } };
      const selected = selectUserRoleDomain(mockedState);

      expect(selected).toEqual({ role: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectUserRoleDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectPaginatedSelectUserRoles', () => {
    it('should select the userRole total', () => {
      const mockedState = { userRoleList: [] };
      const selected = selectPaginatedSelectUserRoles().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectUserRolesTotal', () => {
    it('should select the userRole total', () => {
      const mockedState = { userRoleTotal: 289 };
      const selected = selectUserRoleTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingUserRoles', () => {
    it('should select the \'is fetchingUserRoles\' flag', () => {
      const mockedState = { isFetchingUserRoles: true };
      const selected = selectIsFetchingUserRoles().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is isFormLoading\' flag', () => {
      const mockedState = { isFormLoading: true };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectUserRole', () => {
    it('should select the currentUserRole', () => {
      const mockedState = { currentUserRole: { id: 374, __dummy: '374' } };
      const selected = selectUserRole().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedUserRoles', () => {
    it('should select the paginated userRoles', () => {
      const mockedState = { userRoleList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedUserRoles().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectFormUserRole', () => {
    it('should select currentUserRole and do more stuff', () => {
      const mockedState = { currentUserRole: { id: 374, __dummy: '374' } };
      const selected = selectUserRole().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });
});
