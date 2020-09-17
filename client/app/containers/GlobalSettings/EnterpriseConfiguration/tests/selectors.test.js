import {
  selectConfigurationDomain, selectEnterprise, selectEnterpriseIsLoading,
  selectEnterpriseIsCommitting, selectFormEnterprise, selectEnterpriseTheme
} from '../selectors';

import { initialState } from '../reducer';

describe('Configuration selectors', () => {
  describe('selectConfigurationDomain', () => {
    it('should select the configuration domain', () => {
      const mockedState = {};
      const selected = selectConfigurationDomain(mockedState);

      expect(selected).toEqual({ ...initialState });
    });

    it('should select initialState', () => {
      const mockedState = {};
      const selected = selectConfigurationDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectEnterprise', () => {
    it('should return the selected item', () => {
      const mockedState = { currentEnterprise: {} };
      const selected = selectEnterprise().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectEnterpriseTheme', () => {
    it('should return the selected item', () => {
      const mockedState = { currentEnterprise: { theme: {} } };
      const selected = selectEnterpriseTheme().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectEnterpriseIsLoading', () => {
    it('should select the \' isCommitting\' flag', () => {
      const mockedState = { isCommitting: false };
      const selected = selectEnterpriseIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectEnterpriseIsCommitting', () => {
    it('should select the \' isLoading\' flag', () => {
      const mockedState = { isLoading: false };
      const selected = selectEnterpriseIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectFormEnterprise', () => {
    it('should select currentEnterprise and do more stuff', () => {
      const mockedState = { currentEnterprise: { id: 374, __dummy: '374', timezones: [{ id: 1 }] } };
      const selected = selectFormEnterprise().resultFunc(mockedState);

      expect(selected).toEqual({
        id: 374,
        __dummy: '374',
        time_zone: { label: undefined, value: undefined },
        timezones: [{ label: undefined, value: undefined }] });
    });
  });
});
