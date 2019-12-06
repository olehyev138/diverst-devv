import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectEmailDomain = state => state.emails || initialState;

const selectPaginatedEmails = () => createSelector(
  selectEmailDomain,
  emailState => emailState.emailList
);

const selectEmailsTotal = () => createSelector(
  selectEmailDomain,
  emailState => emailState.emailListTotal
);

const selectEmail = () => createSelector(
  selectEmailDomain,
  emailState => emailState.currentEmail
);

const selectIsFetchingEmails = () => createSelector(
  selectEmailDomain,
  emailState => emailState.isFetchingEmails
);

const selectIsFetchingEmail = () => createSelector(
  selectEmailDomain,
  emailState => emailState.isFetchingEmail
);

const selectIsCommitting = () => createSelector(
  selectEmailDomain,
  emailState => emailState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectEmailDomain,
  emailState => emailState.hasChanged
);

export {
  selectEmailDomain,
  selectPaginatedEmails,
  selectEmailsTotal,
  selectEmail,
  selectIsFetchingEmails,
  selectIsFetchingEmail,
  selectIsCommitting,
  selectHasChanged,
};
