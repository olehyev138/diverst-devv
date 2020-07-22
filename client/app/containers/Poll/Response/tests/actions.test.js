import {
  GET_RESPONSE_BEGIN,
  GET_RESPONSE_SUCCESS,
  GET_RESPONSE_ERROR,
  GET_RESPONSES_BEGIN,
  GET_RESPONSES_SUCCESS,
  GET_RESPONSES_ERROR,
  RESPONSES_UNMOUNT,
} from '../constants';

import {
  getResponseBegin,
  getResponseError,
  getResponseSuccess,
  getResponsesBegin,
  getResponsesError,
  getResponsesSuccess,
  responsesUnmount
} from '../actions';

describe('response actions', () => {
  describe('getResponseBegin', () => {
    it('has a type of GET_RESPONSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_RESPONSE_BEGIN,
        payload: { value: 118 }
      };

      expect(getResponseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getResponseSuccess', () => {
    it('has a type of GET_RESPONSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_RESPONSE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getResponseSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getResponseError', () => {
    it('has a type of GET_RESPONSE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_RESPONSE_ERROR,
        error: { value: 709 }
      };

      expect(getResponseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getResponsesBegin', () => {
    it('has a type of GET_RESPONSES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_RESPONSES_BEGIN,
        payload: { value: 118 }
      };

      expect(getResponsesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getResponsesSuccess', () => {
    it('has a type of GET_RESPONSES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_RESPONSES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getResponsesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getResponsesError', () => {
    it('has a type of GET_RESPONSES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_RESPONSES_ERROR,
        error: { value: 709 }
      };

      expect(getResponsesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('responsesUnmount', () => {
    it('has a type of RESPONSES_UNMOUNT', () => {
      const expected = {
        type: RESPONSES_UNMOUNT,
      };

      expect(responsesUnmount()).toEqual(expected);
    });
  });
});
