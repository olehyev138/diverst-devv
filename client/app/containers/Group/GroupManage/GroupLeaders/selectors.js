import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from "immer";

const selectGroupLeadersDomain = state => state.groupLeaders || initialState;

const selectPaginatedGroupLeaders = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.groupLeaderList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
// const selectPaginatedSelectGroupLeaders = () => createSelector(
//   selectGroupLeadersDomain,
//   groupLeadersState => (
//     Object
//       .values(groupLeadersState.groupLeaderList)
//       .map(user => ({
//         value: user.id,
//         label: `${user.first_name} ${user.last_name}`
//       }))
//   )
// );

const selectFormGroupLeaders = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.groupLeaderList.map(leader => mapForm(leader))
);

const selectGroupLeaderTotal = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.groupLeaderTotal
);

const selectGroupLeader = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.currentGroupLeader
);

const selectIsFetchingGroupLeaders = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.isFetchingGroupLeaders
);

const selectIsCommitting = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => groupLeadersState.isCommitting
);

const selectFormGroupLeader = () => createSelector(
  selectGroupLeadersDomain,
  groupLeadersState => mapForm(groupLeadersState.currentGroupLeader)
);

function mapForm(leader) {
  if (!leader) return null;
  return produce(leader, (draft) => {
    draft.user = { value: leader.user.id, label: leader.user.name };
  });
}


export {
  selectFormGroupLeaders, selectGroupLeadersDomain, selectPaginatedGroupLeaders, selectGroupLeader,
  selectGroupLeaderTotal, selectIsFetchingGroupLeaders, selectIsCommitting,
  selectFormGroupLeader,
};
