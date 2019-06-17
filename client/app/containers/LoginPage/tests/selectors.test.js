import { selectLoginPage, selectEmailError, selectPasswordError } from '../selectors';

describe('LoginPage selectors', () => {
  describe('selectLoginPage', () => {
    it('should select the loginPage state domain', () => {
      const mockedState = { loginPage: { loginPage: 'loginPage' } };
      const selected = selectLoginPage(mockedState);

      expect(selected).toEqual(mockedState.loginPage);
    });
  });

  describe('selectEmailError', () => {
    it('should select the email error', () => {
      const mockedState = { email: { error: 'error' } };
      const selected = selectEmailError().resultFunc(mockedState);

      expect(selected).toEqual('error');
    });
  });

  describe('selectPasswordError', () => {
    it('should select the password error', () => {
      const mockedState = { password: { error: 'error' } };
      const selected = selectPasswordError().resultFunc(mockedState);

      expect(selected).toEqual('error');
    });
  });
});
