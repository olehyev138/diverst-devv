import {
  selectGroupsDomain,
  selectPaginatedGroups,
  selectPaginatedSelectGroups,
  selectGroupTotal,
  selectGroup,
  selectGroupIsLoading,
  selectIsFormLoading,
  selectGroupIsCommitting,
  selectFormGroup,
  selectHasChanged,
} from '../selectors';
import { initialState } from '../reducer';

describe('Group selectors', () => {
  describe('selectGroupsDomain', () => {
    it('should select the groups domain', () => {
      const mockedState = { groups: { group: {} } };
      const selected = selectGroupsDomain(mockedState);

      expect(selected).toEqual({ group: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectGroupsDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectPaginatedGroups', () => {
    it('should select the paginated groups', () => {
      const mockedState = { groupList: { id: 429, __dummy: '429' } };
      const selected = selectPaginatedGroups().resultFunc(mockedState);

      expect(selected).toEqual({ id: 429, __dummy: '429' });
    });
  });

  describe('selectPaginatedSelectGroups', () => {
    // TODO: REQUIRES MANUAL IMPLEMENTATION
    it.skip('should select the paginated select groups', () => {
      const mockedState = 1;
      const selected = 2;

      expect(selected).toEqual(3);
    });
  });

  describe('selectGroupTotal', () => {
    it('should select the group total', () => {
      const mockedState = { groupTotal: 289 };
      const selected = selectGroupTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectGroup', () => {
    it('should select the group', () => {
      const mockedState = { currentGroup: { id: 374, __dummy: '374' } };
      const selected = selectGroup().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectGroupIsLoading', () => {
    it('should select the group is loading', () => {
      const mockedState = { isLoading: { id: 422, __dummy: '422' } };
      const selected = selectGroupIsLoading().resultFunc(mockedState);

      expect(selected).toEqual({ id: 422, __dummy: '422' });
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is form loading\' flag', () => {
      const mockedState = { isFormLoading: false };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectGroupIsCommitting', () => {
    it('should select the group is committing', () => {
      const mockedState = { isCommitting: { id: 893, __dummy: '893' } };
      const selected = selectGroupIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual({ id: 893, __dummy: '893' });
    });
  });

  describe('selectFormGroup', () => {
    // TODO: REQUIRES MANUAL IMPLEMENTATION
    it.skip('should select the form group', () => {
      const mockedState = 1;
      const selected = 2;

      expect(selected).toEqual(3);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
