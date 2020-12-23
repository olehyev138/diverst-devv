import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer';

const selectRegionLeadersDomain = state => state.regionLeaders || initialState;

const selectPaginatedRegionLeaders = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.regionLeaderList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectRegionLeaders = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => (
    Object
      .values(regionLeadersState.regionLeaderList)
      .map(user => ({
        value: user.id,
        label: `${user.name}`
        // label: `${user.first_name} ${user.last_name}`
      }))
  )
);

const selectFormRegionLeaders = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.regionLeaderList.map(leader => mapForm(leader))
);

const selectRegionLeaderTotal = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.regionLeaderTotal
);

const selectRegionLeader = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.currentRegionLeader
);

const selectIsFetchingRegionLeaders = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.isFetchingRegionLeaders
);

const selectIsCommitting = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.isCommitting
);

const selectFormRegionLeader = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => mapForm(regionLeadersState.currentRegionLeader)
);

const selectIsFormLoading = () => createSelector(
  selectRegionLeadersDomain,
  regionLeadersState => regionLeadersState.isFormLoading
);

function mapForm(leader) {
  if (!leader) return null;
  return produce(leader, (draft) => {
    draft.user = { value: leader.user.id, label: leader.user.name };
    draft.user_role = leader.user_role ? { value: leader.user_role.id, label: leader.user_role.role_name } : null;
  });
}


export {
  selectFormRegionLeaders, selectRegionLeadersDomain, selectPaginatedRegionLeaders, selectRegionLeader,
  selectRegionLeaderTotal, selectIsFetchingRegionLeaders, selectIsCommitting,
  selectFormRegionLeader, selectPaginatedSelectRegionLeaders, selectIsFormLoading
};
