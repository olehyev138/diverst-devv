import { createSelector } from 'reselect/lib';

import produce from 'immer';
import dig from 'object-dig';

import { initialState } from './reducer';

const selectUsersDomain = state => state.signup || initialState;

const selectToken = () => createSelector(
  selectUsersDomain,
  usersState => usersState.token
);

const selectUser = () => createSelector(
  selectUsersDomain,
  usersState => usersState.user
);

const selectIsLoading = () => createSelector(
  selectUsersDomain,
  usersState => usersState.isLoading
);

const selectIsCommitting = () => createSelector(
  selectUsersDomain,
  usersState => usersState.isCommitting
);

const selectFormErrors = () => createSelector(
  selectUsersDomain,
  usersState => usersState.errors
);

export {
  selectUsersDomain, selectToken,
  selectIsLoading, selectUser, selectFormErrors,
  selectIsCommitting,
};
