import { createSelector } from 'reselect';

const selectLoginPage = state => state.loginPage;

const selectFormErrors = () => createSelector(
  selectLoginPage,
  loginPageState => loginPageState.formErrors,
);

const selectEmailError = () => createSelector(
  selectLoginPage,
  loginPageState => loginPageState.formErrors.email,
);

const selectPasswordError = () => createSelector(
  selectLoginPage,
  loginPageState => loginPageState.formErrors.password,
);

export { selectFormErrors, selectEmailError, selectPasswordError };
