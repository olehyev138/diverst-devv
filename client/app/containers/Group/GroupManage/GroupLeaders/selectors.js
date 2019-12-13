import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

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
  (groupLeadersState) => {
    const { currentGroupLeader } = groupLeadersState;
    if (!currentGroupLeader) return null;

    // clone group before making mutations on it
    const selectGroupLeader = Object.assign({}, currentGroupLeader);

    selectGroupLeader.groups = selectGroupLeader.groups.map(group => ({
      value: group.id,
      label: group.name
    }));

    return selectGroupLeader;
  }
);

export {
  selectGroupLeadersDomain, selectPaginatedGroupLeaders, selectGroupLeader,
  selectGroupLeaderTotal, selectIsFetchingGroupLeaders, selectIsCommitting,
  selectFormGroupLeader,
};
