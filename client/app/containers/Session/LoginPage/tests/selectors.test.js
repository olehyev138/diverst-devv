import {
  selectLoginPageDomain, selectFormErrors, selectEmailError, selectPasswordError
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
    it('should select the form errors', () => {
      const mockedState = { formErrors: { email: 'error', password: 'error' } };
      const selected = selectFormErrors().resultFunc(mockedState);

      expect(selected).toEqual({
        email: 'error',
        password: 'error'
      });
    });
  });

  describe('selectEmailError', () => {
    it('should select the email error', () => {
      const mockedState = { formErrors: { email: 'error' } };
      const selected = selectEmailError().resultFunc(mockedState);

      expect(selected).toEqual('error');
    });
  });

  describe('selectPasswordError', () => {
    it('should select the password error', () => {
      const mockedState = { formErrors: { password: 'error' } };
      const selected = selectPasswordError().resultFunc(mockedState);

      expect(selected).toEqual('error');
    });
  });
});
