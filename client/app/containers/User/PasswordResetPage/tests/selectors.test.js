import {
  initialState
} from '../reducer';

import {
  selectForgotPasswordDomain,
  selectToken,
  selectIsLoading,
  selectIsCommitting,
  selectUser,
  selectErrors
} from '../selectors';

describe('PasswordResetPage selectors', () => {
  describe('selectForgotPasswordDomain', () => {
    it('should select the ForgotPasswordDomain', () => {
      const mockedState = {
        forgotPassword: {
          forgotPassword: { }
        }
      };

      const selected = selectForgotPasswordDomain(mockedState);
      expect(selected).toEqual({
        forgotPassword: { }
      });
    });

    it('should select initialState', () => {
      const mockedState = { };

      const selected = selectForgotPasswordDomain(mockedState);
      expect(selected).toEqual(initialState);
    });
  });

  describe('selectToken', () => {
    it('should select the Token', () => {
      const mockedState = {
        token: {
          id: 3004,
          __dummy: '3004'
        }
      };

      const selected = selectToken().resultFunc(mockedState);
      expect(selected).toEqual({
        id: 3004,
        __dummy: '3004'
      });
    });
  });

  describe('selectIsLoading', () => {
    it('should select the IsLoading flag', () => {
      const mockedState = {
        isLoading: true
      };

      const selected = selectIsLoading().resultFunc(mockedState);
      expect(selected).toEqual(true);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the IsCommitting flag', () => {
      const mockedState = {
        isCommitting: false
      };

      const selected = selectIsCommitting().resultFunc(mockedState);
      expect(selected).toEqual(false);
    });
  });

  describe('selectUser', () => {
    it('should select the User', () => {
      const mockedState = {
        user: {
          id: 8306,
          __dummy: '8306'
        }
      };

      const selected = selectUser().resultFunc(mockedState);
      expect(selected).toEqual({
        id: 8306,
        __dummy: '8306'
      });
    });
  });

  describe('selectErrors', () => {
    it('should select the Errors', () => {
      const mockedState = {
        errors: {
          id: 4791,
          __dummy: '4791'
        }
      };

      const selected = selectErrors().resultFunc(mockedState);
      expect(selected).toEqual({
        id: 4791,
        __dummy: '4791'
      });
    });
  });
});
