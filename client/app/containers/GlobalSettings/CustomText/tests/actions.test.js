import {
  GET_CUSTOM_TEXT_BEGIN,
  GET_CUSTOM_TEXT_SUCCESS,
  GET_CUSTOM_TEXT_ERROR,
  UPDATE_CUSTOM_TEXT_BEGIN,
  UPDATE_CUSTOM_TEXT_SUCCESS,
  UPDATE_CUSTOM_TEXT_ERROR,
  CUSTOM_TEXT_UNMOUNT
} from 'containers/GlobalSettings/CustomText/constants';

import {
  getCustomTextBegin,
  getCustomTextSuccess,
  getCustomTextError,
  updateCustomTextBegin,
  updateCustomTextSuccess,
  updateCustomTextError,
  customTextUnmount
} from 'containers/GlobalSettings/CustomText/actions';

describe('CustomText actions', () => {
  describe('CustomText getting actions', () => {
    describe('getCustomTextBegin', () => {
      it('has a type of GET_CUSTOM_TEXT_BEGIN', () => {
        const expected = {
          type: GET_CUSTOM_TEXT_BEGIN,
        };

        expect(getCustomTextBegin()).toEqual(expected);
      });
    });

    describe('getCustomTextSuccess', () => {
      it('has a type of GET_CUSTOM_TEXT_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_CUSTOM_TEXT_SUCCESS,
          payload: {}
        };

        expect(getCustomTextSuccess({})).toEqual(expected);
      });
    });

    describe('getCustomTextError', () => {
      it('has a type of GET_CUSTOM_TEXT_ERROR and sets a given error', () => {
        const expected = {
          type: GET_CUSTOM_TEXT_ERROR,
          error: 'error'
        };

        expect(getCustomTextError('error')).toEqual(expected);
      });
    });
  });

  describe('CustomText updating actions', () => {
    describe('updateCustomTextBegin', () => {
      it('has a type of UPDATE_CUSTOM_TEXT_BEGIN', () => {
        const expected = {
          type: UPDATE_CUSTOM_TEXT_BEGIN,
        };

        expect(updateCustomTextBegin()).toEqual(expected);
      });
    });

    describe('updateCustomTextSuccess', () => {
      it('has a type of UPDATE_CUSTOM_TEXTS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_CUSTOM_TEXT_SUCCESS,
          payload: {}
        };

        expect(updateCustomTextSuccess({})).toEqual(expected);
      });
    });

    describe('updateCustomTextError', () => {
      it('has a type of UPDATE_CUSTOM_TEXT_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_CUSTOM_TEXT_ERROR,
          error: 'error'
        };

        expect(updateCustomTextError('error')).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('customTextUnmount', () => {
      it('has a type of CUSTOM_TEXTS_UNMOUNT', () => {
        const expected = {
          type: CUSTOM_TEXT_UNMOUNT
        };

        expect(customTextUnmount()).toEqual(expected);
      });
    });
  });
});
