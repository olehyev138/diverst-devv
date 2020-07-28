import {
  requestPasswordResetBegin,
  requestPasswordResetSuccess,
  requestPasswordResetError,
  getUserByTokenBegin,
  getUserByTokenSuccess,
  getUserByTokenError,
  submitPasswordBegin,
  submitPasswordSuccess,
  submitPasswordError,
  signUpUnmount
} from '../actions';

import {
  REQUEST_PASSWORD_RESET_BEGIN,
  REQUEST_PASSWORD_RESET_SUCCESS,
  REQUEST_PASSWORD_RESET_ERROR,
  GET_USER_BY_TOKEN_BEGIN,
  GET_USER_BY_TOKEN_SUCCESS,
  GET_USER_BY_TOKEN_ERROR,
  SUBMIT_PASSWORD_BEGIN,
  SUBMIT_PASSWORD_SUCCESS,
  SUBMIT_PASSWORD_ERROR,
  SIGN_UP_UNMOUNT
} from '../constants';

describe('PasswordResetPage actions', () => {
  describe('password reset requesting actions', () => {
    describe('requestPasswordResetBegin', () => {
      it('has a type of REQUEST_PASSWORD_RESET_BEGIN and sets a given payload', () => {
        const expected = {
          type: REQUEST_PASSWORD_RESET_BEGIN,
          payload: {
            value: 5953
          }
        };

        expect(requestPasswordResetBegin({
          value: 5953
        })).toEqual(expected);
      });
    });

    describe('requestPasswordResetSuccess', () => {
      it('has a type of REQUEST_PASSWORD_RESET_SUCCESS and sets a given payload', () => {
        const expected = {
          type: REQUEST_PASSWORD_RESET_SUCCESS,
          payload: {
            value: 4258
          }
        };

        expect(requestPasswordResetSuccess({
          value: 4258
        })).toEqual(expected);
      });
    });

    describe('requestPasswordResetError', () => {
      it('has a type of REQUEST_PASSWORD_RESET_ERROR and sets a given error', () => {
        const expected = {
          type: REQUEST_PASSWORD_RESET_ERROR,
          error: {
            value: 6278
          }
        };

        expect(requestPasswordResetError({
          value: 6278
        })).toEqual(expected);
      });
    });
  });

  describe('user getting actions', () => {
    describe('getUserByTokenBegin', () => {
      it('has a type of GET_USER_BY_TOKEN_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_USER_BY_TOKEN_BEGIN,
          payload: {
            value: 2021
          }
        };

        expect(getUserByTokenBegin({
          value: 2021
        })).toEqual(expected);
      });
    });

    describe('getUserByTokenSuccess', () => {
      it('has a type of GET_USER_BY_TOKEN_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_USER_BY_TOKEN_SUCCESS,
          payload: {
            value: 2655
          }
        };

        expect(getUserByTokenSuccess({
          value: 2655
        })).toEqual(expected);
      });
    });

    describe('getUserByTokenError', () => {
      it('has a type of GET_USER_BY_TOKEN_ERROR and sets a given error', () => {
        const expected = {
          type: GET_USER_BY_TOKEN_ERROR,
          error: {
            value: 7851
          }
        };

        expect(getUserByTokenError({
          value: 7851
        })).toEqual(expected);
      });
    });
  });

  describe('password submitting actions', () => {
    describe('submitPasswordBegin', () => {
      it('has a type of SUBMIT_PASSWORD_BEGIN and sets a given payload', () => {
        const expected = {
          type: SUBMIT_PASSWORD_BEGIN,
          payload: {
            value: 3167
          }
        };

        expect(submitPasswordBegin({
          value: 3167
        })).toEqual(expected);
      });
    });

    describe('submitPasswordSuccess', () => {
      it('has a type of SUBMIT_PASSWORD_SUCCESS and sets a given payload', () => {
        const expected = {
          type: SUBMIT_PASSWORD_SUCCESS,
          payload: {
            value: 6470
          }
        };

        expect(submitPasswordSuccess({
          value: 6470
        })).toEqual(expected);
      });
    });

    describe('submitPasswordError', () => {
      it('has a type of SUBMIT_PASSWORD_ERROR and sets a given error', () => {
        const expected = {
          type: SUBMIT_PASSWORD_ERROR,
          error: {
            value: 2003
          }
        };

        expect(submitPasswordError({
          value: 2003
        })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('signUpUnmount', () => {
      it('has a type of SIGN_UP_UNMOUNT', () => {
        const expected = {
          type: SIGN_UP_UNMOUNT
        };

        expect(signUpUnmount()).toEqual(expected);
      });
    });
  });
});
