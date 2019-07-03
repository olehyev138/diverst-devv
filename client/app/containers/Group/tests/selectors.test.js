import { selectGroupsDomain } from 'containers/Group/selectors';

describe('Group selectors', () => {
  describe('selectGroupsDomain', () => {
    it('should select the groups domain', () => {
      const mockedState = { groups: { group: {} } };
      const selected = selectGroupsDomain(mockedState);

      expect(selected).toEqual({ group: {} });
    });
  });
});
