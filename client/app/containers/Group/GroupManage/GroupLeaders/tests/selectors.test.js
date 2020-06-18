import {
  selectFormGroupLeaders, selectGroupLeadersDomain, selectPaginatedGroupLeaders, selectGroupLeader,
  selectGroupLeaderTotal, selectIsFetchingGroupLeaders, selectIsCommitting,
  selectFormGroupLeader, selectPaginatedSelectGroupLeaders, selectIsFormLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('GroupLeader selectors', () => {
  describe('selectGroupLeaderDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { groupLeaders: { groupLeader: {} } };
      const selected = selectGroupLeadersDomain(mockedState);

      expect(selected).toEqual({ groupLeader: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectGroupLeadersDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectGroupLeaderTotal', () => {
    it('should select the group leader total', () => {
      const mockedState = { groupLeaderTotal: 289 };
      const selected = selectGroupLeaderTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingGroupLeaders', () => {
    it('should select the \'is fetchingGroupLeaders\' flag', () => {
      const mockedState = { isFetchingGroupLeaders: true };
      const selected = selectIsFetchingGroupLeaders().resultFunc(mockedState);

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

  describe('selectGroupLeader', () => {
    it('should select the currentGroupLeader', () => {
      const mockedState = { currentGroupLeader: { id: 374, __dummy: '374' } };
      const selected = selectGroupLeader().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedGroupLeaders', () => {
    it('should select the paginated groupLeaders', () => {
      const mockedState = { groupLeaderList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedGroupLeaders().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectFormGroupLeaders', () => {
    it('should select the form groupLeaders', () => {
      const mockedState = { groupLeaderList: [{ user: { id: 37, name: 'dummy' }, user_role: { id: 37, role_name: 'dummy' } }] };
      const selected = selectFormGroupLeaders().resultFunc(mockedState);

      expect(selected).toEqual([{ user: { label: 'dummy', value: 37 }, user_role: { label: 'dummy', value: 37} }]);
    });
  });
});
