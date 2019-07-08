import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/reducer';

const selectGroupsDomain = state => state.groups || initialState;

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList
);

const selectPaginatedSelectGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => (
    Object
      .values(groupsState.groupList)
      .map(group => ({ value: group.id, label: group.name }))
  )
);

const selectGroupTotal = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupTotal
);

const selectGroup = id => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList[`${id}`] || null
);

export {
  selectGroupsDomain, selectPaginatedGroups, selectPaginatedSelectGroups,
  selectGroupTotal, selectGroup
};
