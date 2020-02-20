import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectForgotPasswordPageDomain = state => state.forgotPasswordPage || initialState;

const selectIsLoggingIn = () => createSelector(
  selectForgotPasswordPageDomain,
  ForgotPasswordPageState => ForgotPasswordPageState.isLoggingIn
);

const selectLoginSuccess = () => createSelector(
  selectForgotPasswordPageDomain,
  ForgotPasswordPageState => ForgotPasswordPageState.loginSuccess
);

export {
  selectIsLoggingIn, selectLoginSuccess
};
