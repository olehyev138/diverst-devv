import {
  GET_ENTERPRISE_BEGIN,
  GET_ENTERPRISE_SUCCESS,
  GET_ENTERPRISE_ERROR,
  UPDATE_ENTERPRISE_BEGIN,
  UPDATE_ENTERPRISE_SUCCESS,
  UPDATE_ENTERPRISE_ERROR,
  CONFIGURATION_UNMOUNT,
} from '../constants';

import {
  getEnterpriseBegin,
  getEnterpriseError,
  getEnterpriseSuccess,
  updateEnterpriseBegin,
  updateEnterpriseError,
  updateEnterpriseSuccess,
  configurationUnmount
} from '../actions';

describe('enterprise actions', () => {
  describe('getEnterpriseBegin', () => {
    it('has a type of GET_ENTERPRISE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_ENTERPRISE_BEGIN,
        payload: { value: 118 }
      };

      expect(getEnterpriseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getEnterpriseSuccess', () => {
    it('has a type of GET_ENTERPRISE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_ENTERPRISE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getEnterpriseSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getEnterpriseError', () => {
    it('has a type of GET_ENTERPRISE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_ENTERPRISE_ERROR,
        error: { value: 709 }
      };

      expect(getEnterpriseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateEnterpriseBegin', () => {
    it('has a type of UPDATE_ENTERPRISE_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_ENTERPRISE_BEGIN,
        payload: { value: 118 }
      };

      expect(updateEnterpriseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateEnterpriseSuccess', () => {
    it('has a type of UPDATE_ENTERPRISE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_ENTERPRISE_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateEnterpriseSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateEnterpriseError', () => {
    it('has a type of UPDATE_ENTERPRISE_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_ENTERPRISE_ERROR,
        error: { value: 709 }
      };

      expect(updateEnterpriseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('configurationUnmount', () => {
    it('has a type of CONFIGURATION_UNMOUNT', () => {
      const expected = {
        type: CONFIGURATION_UNMOUNT,
      };

      expect(configurationUnmount()).toEqual(expected);
    });
  });
});
