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
      .map(member => ({
        value: member.user.id,
        label: `${member.user.name}`
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

const selectHasChanged = () => createSelector(
  selectMembersDomain,
  membersState => membersState.hasChanged
);

export {
  selectMembersDomain, selectPaginatedMembers, selectPaginatedSelectMembers,
  selectMemberTotal, selectIsFetchingMembers, selectIsCommitting, selectHasChanged
};
