import {
  selectMembersDomain,
  selectPaginatedMembers,
  selectPaginatedSelectMembers,
  selectIsFetchingMembers,
  selectIsCommitting,
  selectMemberTotal,
} from '../selectors';

import { initialState } from '../reducer';

describe('Member selectors', () => {
  describe('selectMemberDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { members: { member: {} } };
      const selected = selectMembersDomain(mockedState);

      expect(selected).toEqual({ member: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectMembersDomain(mockedState);

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

  describe('selectMembersTotal', () => {
    it('should select the member total', () => {
      const mockedState = { memberTotal: 289 };
      const selected = selectMemberTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingMembers', () => {
    it('should select the \'is fetchingMembers\' flag', () => {
      const mockedState = { isFetchingMembers: true };
      const selected = selectIsFetchingMembers().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPaginatedMembers', () => {
    it('should select the paginated members', () => {
      const mockedState = { memberList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedMembers().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectPaginatedSelectMembers', () => {
    it('should select the paginated members', () => {
      const mockedState = { memberList: [{ user: { id: 37, name: 'dummy' } }] };
      const selected = selectPaginatedSelectMembers().resultFunc(mockedState);

      expect(selected).toEqual([{ value: 37, label: 'dummy' }]);
    });
  });
});
