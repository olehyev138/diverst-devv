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
  (groupsState) => {
    if (Object.prototype.hasOwnProperty.call(groupsState.groupList, `${id}`))
      return groupsState.groupList[`${id}`];

    return null;
  }
);

export {
  selectGroupsDomain, selectPaginatedGroups,
  selectGroupTotal, selectGroup
};
