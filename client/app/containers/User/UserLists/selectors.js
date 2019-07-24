import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/User/UserLists/reducer';

const selectUserListDomain = state => state.userList || initialState;

const selectPaginatedUsers = () => createSelector(
  selectUserListDomain,
  groupsState => groupsState.groupList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectUsers = () => createSelector(
  selectUserListDomain,
  groupsState => (
    Object
      .values(groupsState.groupList)
      .map(group => ({ value: group.id, label: group.name }))
  )
);

const selectUserTotal = () => createSelector(
  selectUserListDomain,
  groupsState => groupsState.groupTotal
);

export {
  selectUserListDomain, selectPaginatedUsers, selectPaginatedSelectUsers,
  selectUserTotal
};
