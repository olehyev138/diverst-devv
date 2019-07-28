import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/Group/GroupMembers/reducer';

const selectMembersDomain = state => state.members || initialState;

const selectPaginatedUsers = () => createSelector(
  selectMembersDomain,
  membersState => membersState.userList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectUsers = () => createSelector(
  selectMembersDomain,
  membersState => (
    Object
      .values(membersState.userList)
      .map(user => ({
        value: user.id,
        label: `${user.first_name} ${user.last_name}`
      }))
  )
);

const selectUserTotal = () => createSelector(
  selectMembersDomain,
  membersState => membersState.userTotal
);

export {
  selectMembersDomain, selectPaginatedUsers, selectPaginatedSelectUsers,
  selectUserTotal
};
