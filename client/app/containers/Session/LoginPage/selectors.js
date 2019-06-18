import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectLoginPageDomain = state => state.loginPage || initialState;

const selectFormErrors = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.formErrors,
);

const selectEmailError = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.formErrors.email,
);

const selectPasswordError = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.formErrors.password,
);

export {
  selectLoginPageDomain, selectFormErrors, selectEmailError, selectPasswordError
};
