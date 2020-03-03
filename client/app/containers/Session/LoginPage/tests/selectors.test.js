import {
  selectLoginPageDomain, selectLoginSuccess, selectIsLoggingIn
} from '../selectors';

describe('LoginPage selectors', () => {
  describe('selectLoginPage', () => {
    it('should select the loginPage state domain', () => {
      const mockedState = { loginPage: { loginPage: 'loginPage' } };
      const selected = selectLoginPageDomain(mockedState);

      expect(selected).toEqual(mockedState.loginPage);
    });
  });

  describe('selectFormErrors', () => {
    it('should select isLoggingIn', () => {
      const mockedState = { isLoggingIn: true };
      const selected = selectIsLoggingIn().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectEmailError', () => {
    it('should select loginSuccess', () => {
      const mockedState = { loginSuccess: true };
      const selected = selectLoginSuccess().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });
});
