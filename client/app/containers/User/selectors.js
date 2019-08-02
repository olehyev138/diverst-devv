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

const selectFormUser = () => createSelector(
  selectUsersDomain,
  (usersState) => {
    const { currentUser } = usersState;
    if (!currentUser) return null;

    // clone user before making mutations on it
    const selectUser = Object.assign({}, currentUser);

    selectUser.children = selectUser.children.map(child => ({
      value: child.id,
      label: child.name
    }));

    return selectUser;
  }
);

export {
  selectUsersDomain, selectPaginatedUsers,
  selectUserTotal, selectUser, selectFormUser
};
