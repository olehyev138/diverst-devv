import {
  selectSSOSettingsDomain,
  selectIsCommitting,
} from '../selectors';

import { initialState } from '../reducer';

describe('Configuration selectors', () => {
  describe('selectSSOSettingsDomain', () => {
    it('should select the configuration domain', () => {
      const mockedState = {};
      const selected = selectSSOSettingsDomain(mockedState);

      expect(selected).toEqual({ ...initialState });
    });

    it('should select initialState', () => {
      const mockedState = {};
      const selected = selectSSOSettingsDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });
});
