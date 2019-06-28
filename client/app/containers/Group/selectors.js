import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/reducer';

const selectGroupsDomain = state => state.groups || initialState;

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList
);

const selectGroupTotal = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupTotal
);

const selectGroup = id => createSelector(
  selectGroupsDomain,
  groupsState => {
    // (groupsState.groups ? groupsState.groups[`${id}`] : null)

    if (groupsState.groupList.hasOwnProperty(`${id}`))
      return groupsState.groupList[`${id}`];

    return null;
  }
);

export { selectPaginatedGroups, selectGroupTotal, selectGroup };
