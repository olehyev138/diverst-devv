import {
  UPDATE_SSO_SETTINGS_BEGIN,
  UPDATE_SSO_SETTINGS_SUCCESS,
  UPDATE_SSO_SETTINGS_ERROR,
} from '../constants';

import {
  updateSsoSettingsBegin,
  updateSsoSettingsSuccess,
  updateSsoSettingsError,
} from '../actions';

describe('sso actions', () => {
  describe('updateSsoSettingsBegin', () => {
    it('has a type of UPDATE_SSO_SETTINGS_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_SSO_SETTINGS_BEGIN,
        payload: { value: 118 }
      };

      expect(updateSsoSettingsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateSsoSettingsSuccess', () => {
    it('has a type of UPDATE_SSO_SETTINGS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_SSO_SETTINGS_SUCCESS,
        payload: { value: 865 }
      };

      expect(updateSsoSettingsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('updateSsoSettingsError', () => {
    it('has a type of UPDATE_SSO_SETTINGS_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_SSO_SETTINGS_ERROR,
        error: { value: 709 }
      };

      expect(updateSsoSettingsError({ value: 709 })).toEqual(expected);
    });
  });
});
