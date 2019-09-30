import {
  UPDATE_CUSTOM_TEXT_BEGIN,
  UPDATE_CUSTOM_TEXT_SUCCESS,
  UPDATE_CUSTOM_TEXT_ERROR,
} from 'containers/GlobalSettings/CustomText/constants';

import {
  updateCustomTextBegin,
  updateCustomTextSuccess,
  updateCustomTextError,
} from 'containers/GlobalSettings/CustomText/actions';

describe('CustomText actions', () => {
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
});
