import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectForgotPasswordDomain = state => state.forgotPassword || initialState;

const selectToken = () => createSelector(
  selectForgotPasswordDomain,
  forgotPasswordState => forgotPasswordState.token
);

const selectIsLoading = () => createSelector(
  selectForgotPasswordDomain,
  forgotPasswordState => forgotPasswordState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectForgotPasswordDomain,
  forgotPasswordState => forgotPasswordState.isCommitting
);

const selectUser = () => createSelector(
  selectForgotPasswordDomain,
  forgotPasswordState => forgotPasswordState.user
);

const selectErrors = () => createSelector(
  selectForgotPasswordDomain,
  forgotPasswordState => forgotPasswordState.errors
);

export {
  selectForgotPasswordDomain,
  selectToken,
  selectIsLoading,
  selectIsCommitting,
  selectUser,
  selectErrors,
};
