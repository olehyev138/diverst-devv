import {
  GET_USER_BY_TOKEN_BEGIN,
  GET_USER_BY_TOKEN_SUCCESS,
  GET_USER_BY_TOKEN_ERROR,
  SUBMIT_PASSWORD_BEGIN,
  SUBMIT_PASSWORD_SUCCESS,
  SUBMIT_PASSWORD_ERROR,
  SIGN_UP_UNMOUNT,
} from 'containers/User/SignUpPage/constants';

import {
  getUserByTokenBegin,
  getUserByTokenSuccess,
  getUserByTokenError,
  submitPasswordBegin,
  submitPasswordSuccess,
  submitPasswordError,
  signUpUnmount
} from '../actions';

describe('signUp actions', () => {
  describe('getUserByTokenBegin', () => {
    it('has a type of GET_USER_BY_TOKEN_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_BY_TOKEN_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserByTokenBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserByTokenSuccess', () => {
    it('has a type of GET_USER_BY_TOKEN_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_BY_TOKEN_SUCCESS,
        payload: { value: 118 }
      };

      expect(getUserByTokenSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserByTokenError', () => {
    it('has a type of GET_USER_BY_TOKEN_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_BY_TOKEN_ERROR,
        error: { value: 709 }
      };

      expect(getUserByTokenError({ value: 709 })).toEqual(expected);
    });
  });

  describe('submitPasswordBegin', () => {
    it('has a type of SUBMIT_PASSWORD_BEGIN and sets a given payload', () => {
      const expected = {
        type: SUBMIT_PASSWORD_BEGIN,
        payload: { value: 118 }
      };

      expect(submitPasswordBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('submitPasswordSuccess', () => {
    it('has a type of SUBMIT_PASSWORD_SUCCESS and sets a given payload', () => {
      const expected = {
        type: SUBMIT_PASSWORD_SUCCESS,
        payload: { value: 118 }
      };

      expect(submitPasswordSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('submitPasswordError', () => {
    it('has a type of SUBMIT_PASSWORD_ERROR and sets a given error', () => {
      const expected = {
        type: SUBMIT_PASSWORD_ERROR,
        error: { value: 709 }
      };

      expect(submitPasswordError({ value: 709 })).toEqual(expected);
    });
  });

  describe('signUpUnmount', () => {
    it('has a type of SIGN_UP_UNMOUNT', () => {
      const expected = {
        type: SIGN_UP_UNMOUNT,
      };

      expect(signUpUnmount()).toEqual(expected);
    });
  });
});
