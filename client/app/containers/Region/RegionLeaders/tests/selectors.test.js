import {
  selectFormRegionLeaders, selectRegionLeadersDomain, selectPaginatedRegionLeaders, selectRegionLeader,
  selectRegionLeaderTotal, selectIsFetchingRegionLeaders, selectIsCommitting,
  selectFormRegionLeader, selectPaginatedSelectRegionLeaders, selectIsFormLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('RegionLeader selectors', () => {
  describe('selectRegionLeaderDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { regionLeaders: { regionLeader: {} } };
      const selected = selectRegionLeadersDomain(mockedState);

      expect(selected).toEqual({ regionLeader: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectRegionLeadersDomain(mockedState);

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

  describe('selectRegionLeaderTotal', () => {
    it('should select the region leader total', () => {
      const mockedState = { regionLeaderTotal: 289 };
      const selected = selectRegionLeaderTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingRegionLeaders', () => {
    it('should select the \'is fetchingRegionLeaders\' flag', () => {
      const mockedState = { isFetchingRegionLeaders: true };
      const selected = selectIsFetchingRegionLeaders().resultFunc(mockedState);

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

  describe('selectRegionLeader', () => {
    it('should select the currentRegionLeader', () => {
      const mockedState = { currentRegionLeader: { id: 374, __dummy: '374' } };
      const selected = selectRegionLeader().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedRegionLeaders', () => {
    it('should select the paginated regionLeaders', () => {
      const mockedState = { regionLeaderList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedRegionLeaders().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectFormRegionLeaders', () => {
    it('should select the form regionLeaders', () => {
      const mockedState = { regionLeaderList: [{ user: { id: 37, name: 'dummy' }, user_role: { id: 37, role_name: 'dummy' } }] };
      const selected = selectFormRegionLeaders().resultFunc(mockedState);

      expect(selected).toEqual([{ user: { label: 'dummy', value: 37 }, user_role: { label: 'dummy', value: 37 } }]);
    });
  });
});
