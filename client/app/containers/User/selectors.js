import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/User/reducer';

const selectUsersDomain = state => state.users || initialState;

const selectPaginatedUsers = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userList
);

const selectUserTotal = () => createSelector(
  selectUsersDomain,
  usersState => usersState.userTotal
);

const selectUser = () => createSelector(
  selectUsersDomain,
  usersState => usersState.currentUser
);

export {
  selectUsersDomain, selectPaginatedUsers,
  selectUserTotal, selectUser
};
