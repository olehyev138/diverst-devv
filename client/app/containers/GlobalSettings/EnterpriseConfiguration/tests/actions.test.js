import {
  GET_ENTERPRISE_BEGIN,
  GET_ENTERPRISE_SUCCESS,
  GET_ENTERPRISE_ERROR,
  UPDATE_ENTERPRISE_BEGIN,
  UPDATE_ENTERPRISE_SUCCESS,
  UPDATE_ENTERPRISE_ERROR,
  UPDATE_BRANDING_BEGIN,
  UPDATE_BRANDING_SUCCESS,
  UPDATE_BRANDING_ERROR,
  CONFIGURATION_UNMOUNT,
} from '../constants';

import {
  getEnterpriseBegin,
  getEnterpriseSuccess,
  getEnterpriseError,
  updateEnterpriseBegin,
  updateEnterpriseSuccess,
  updateEnterpriseError,
  updateBrandingBegin,
  updateBrandingSuccess,
  updateBrandingError,
  configurationUnmount,
} from '../actions';

describe('enterpriseconfiguration actions', () => {
  describe('enterprise get actions', () => {
    describe('getEnterpriseBegin', () => {
      it('has a type of GET_ENTERPRISE_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_ENTERPRISE_BEGIN,
          payload: { value: 617 }
        };

        expect(getEnterpriseBegin({ value: 617 })).toEqual(expected);
      });
    });

    describe('getEnterpriseSuccess', () => {
      it('has a type of GET_ENTERPRISE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_ENTERPRISE_SUCCESS,
          payload: { value: 929 }
        };

        expect(getEnterpriseSuccess({ value: 929 })).toEqual(expected);
      });
    });

    describe('getEnterpriseError', () => {
      it('has a type of GET_ENTERPRISE_ERROR and sets a given error', () => {
        const expected = {
          type: GET_ENTERPRISE_ERROR,
          error: { value: 973 }
        };

        expect(getEnterpriseError({ value: 973 })).toEqual(expected);
      });
    });
  });

  describe('enterprise update actions', () => {
    describe('updateEnterpriseBegin', () => {
      it('has a type of UPDATE_ENTERPRISE_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_ENTERPRISE_BEGIN,
          payload: { value: 576 }
        };

        expect(updateEnterpriseBegin({ value: 576 })).toEqual(expected);
      });
    });

    describe('updateEnterpriseSuccess', () => {
      it('has a type of UPDATE_ENTERPRISE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_ENTERPRISE_SUCCESS,
          payload: { value: 955 }
        };

        expect(updateEnterpriseSuccess({ value: 955 })).toEqual(expected);
      });
    });

    describe('updateEnterpriseError', () => {
      it('has a type of UPDATE_ENTERPRISE_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_ENTERPRISE_ERROR,
          error: { value: 436 }
        };

        expect(updateEnterpriseError({ value: 436 })).toEqual(expected);
      });
    });
  });

  describe('branding update actions', () => {
    describe('updateBrandingBegin', () => {
      it('has a type of UPDATE_BRANDING_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_BRANDING_BEGIN,
          payload: { value: 761 }
        };

        expect(updateBrandingBegin({ value: 761 })).toEqual(expected);
      });
    });

    describe('updateBrandingSuccess', () => {
      it('has a type of UPDATE_BRANDING_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_BRANDING_SUCCESS,
          payload: { value: 506 }
        };

        expect(updateBrandingSuccess({ value: 506 })).toEqual(expected);
      });
    });

    describe('updateBrandingError', () => {
      it('has a type of UPDATE_BRANDING_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_BRANDING_ERROR,
          error: { value: 502 }
        };

        expect(updateBrandingError({ value: 502 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('configurationUnmount', () => {
      it('has a type of CONFIGURATION_UNMOUNT', () => {
        const expected = {
          type: CONFIGURATION_UNMOUNT,
        };

        expect(configurationUnmount()).toEqual(expected);
      });
    });
  });
});
