import {
  GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
  GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS,
  GET_QUESTIONNAIRE_BY_TOKEN_ERROR,
  SUBMIT_RESPONSE_BEGIN,
  SUBMIT_RESPONSE_SUCCESS,
  SUBMIT_RESPONSE_ERROR,
  POLL_RESPONSE_UNMOUNT,
} from '../constants';

import {
  getQuestionnaireByTokenBegin,
  getQuestionnaireByTokenSuccess,
  getQuestionnaireByTokenError,
  submitResponseBegin,
  submitResponseSuccess,
  submitResponseError,
  pollResponseUnmount
} from '../actions';

describe('pollResponse actions', () => {
  describe('getQuestionnaireByTokenBegin', () => {
    it('has a type of GET_QUESTIONNAIRE_BY_TOKEN_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
        payload: { value: 118 }
      };

      expect(getQuestionnaireByTokenBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getQuestionnaireByTokenSuccess', () => {
    it('has a type of GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS,
        payload: { value: 118 }
      };

      expect(getQuestionnaireByTokenSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getQuestionnaireByTokenError', () => {
    it('has a type of GET_QUESTIONNAIRE_BY_TOKEN_ERROR and sets a given error', () => {
      const expected = {
        type: GET_QUESTIONNAIRE_BY_TOKEN_ERROR,
        error: { value: 709 }
      };

      expect(getQuestionnaireByTokenError({ value: 709 })).toEqual(expected);
    });
  });

  describe('submitResponseBegin', () => {
    it('has a type of SUBMIT_RESPONSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: SUBMIT_RESPONSE_BEGIN,
        payload: { value: 118 }
      };

      expect(submitResponseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('submitResponseSuccess', () => {
    it('has a type of SUBMIT_RESPONSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: SUBMIT_RESPONSE_SUCCESS,
        payload: { value: 118 }
      };

      expect(submitResponseSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('submitResponseError', () => {
    it('has a type of SUBMIT_RESPONSE_ERROR and sets a given error', () => {
      const expected = {
        type: SUBMIT_RESPONSE_ERROR,
        error: { value: 709 }
      };

      expect(submitResponseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('pollResponseUnmount', () => {
    it('has a type of POLL_RESPONSE_UNMOUNT', () => {
      const expected = {
        type: POLL_RESPONSE_UNMOUNT,
      };

      expect(pollResponseUnmount()).toEqual(expected);
    });
  });
});
