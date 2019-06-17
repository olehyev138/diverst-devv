import { createSelector } from 'reselect';

const selectLoginPage = state => state.loginPage;

const selectEmailError = () => createSelector(
  selectLoginPage,
  loginPageState => loginPageState.email.error,
);

const selectPasswordError = () => createSelector(
  selectLoginPage,
  loginPageState => loginPageState.password.error,
);

export { selectLoginPage, selectEmailError, selectPasswordError };
