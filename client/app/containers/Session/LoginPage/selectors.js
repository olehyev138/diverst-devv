import { createSelector } from 'reselect';
import { initialState } from './reducer';
import dig from 'object-dig';

const selectLoginPageDomain = state => state.loginPage || initialState;

const selectFormErrors = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.formErrors,
);

const selectEmailError = () => createSelector(
  selectLoginPageDomain,
  loginPageState => dig(loginPageState, 'formErrors', 'email'),
);

const selectPasswordError = () => createSelector(
  selectLoginPageDomain,
  loginPageState => dig(loginPageState, 'formErrors', 'password')
);

export {
  selectLoginPageDomain, selectFormErrors, selectEmailError, selectPasswordError
};
