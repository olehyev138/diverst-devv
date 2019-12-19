import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/Group/GroupMembers/reducer';

const selectMembersDomain = state => state.members || initialState;

const selectPaginatedMembers = () => createSelector(
  selectMembersDomain,
  membersState => membersState.memberList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectMembers = () => createSelector(
  selectMembersDomain,
  membersState => (
    Object
      .values(membersState.memberList)
      .map(user => ({
        value: user.id,
        label: `${user.first_name} ${user.last_name}`
      }))
  )
);

const selectPaginatedSelectMembersLeaderForm = () => createSelector(
  selectMembersDomain,
  membersState => (
    Object
      .values(membersState.memberList)
      .map(user => ({
        value: user.user.id,
        // label: `${user.first_name} ${user.last_name}`
        label: `${user.user.name}`
      }))
  )
);

const selectMemberTotal = () => createSelector(
  selectMembersDomain,
  membersState => membersState.memberTotal
);

const selectIsFetchingMembers = () => createSelector(
  selectMembersDomain,
  membersState => membersState.isFetchingMembers
);

const selectIsCommitting = () => createSelector(
  selectMembersDomain,
  membersState => membersState.isCommitting
);

export {
  selectMembersDomain, selectPaginatedMembers, selectPaginatedSelectMembers,
  selectPaginatedSelectMembersLeaderForm,
  selectMemberTotal, selectIsFetchingMembers, selectIsCommitting
};
