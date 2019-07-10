import {
  selectGroupsDomain, selectPaginatedGroups,
  selectGroupTotal, selectGroup
} from 'containers/Group/selectors';

describe('Group selectors', () => {
  describe('selectGroupsDomain', () => {
    it('should select the groups domain', () => {
      const mockedState = { groups: { group: {} } };
      const selected = selectGroupsDomain(mockedState);

      expect(selected).toEqual({ group: {} });
    });
  });

  describe('selectPaginatedGroup', () => {
    it('should select the paginated groups', () => {
      const mockedState = { groupList: { 43: {} } };
      const selected = selectPaginatedGroups().resultFunc(mockedState);

      expect(selected).toEqual({ 43: {} });
    });
  });

  describe('selectGroupTotal', () => {
    it('should select the group total', () => {
      const mockedState = { groupTotal: 59 };
      const selected = selectGroupTotal().resultFunc(mockedState);

      expect(selected).toEqual(59);
    });
  });

  describe('selectGroup', () => {
    it('should select the current group', () => {
      const mockedState = { currentGroup: { name: 'dummy-01' } };
      const selected = selectGroup(43).resultFunc(mockedState);

      expect(selected).toEqual({ name: 'dummy-01' });
    });
  });
});
