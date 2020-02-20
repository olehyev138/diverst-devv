import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectLoginPageDomain = state => state.loginPage || initialState;

const selectIsLoggingIn = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.isLoggingIn
);

const selectLoginSuccess = () => createSelector(
  selectLoginPageDomain,
  loginPageState => loginPageState.loginSuccess
);

export {
  selectLoginPageDomain, selectIsLoggingIn, selectLoginSuccess
};
