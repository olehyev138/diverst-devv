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

const selectGroup = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.currentGroup
);

const selectFormGroup = () => createSelector(
  selectGroupsDomain,
  (groupsState) => {
    const group = groupsState.currentGroup;

    if (!group) return null;

    group.children = group.children.map(child => ({
      value: child.id,
      label: child.name
    }));

    return group;
  }
);

export {
  selectGroupsDomain, selectPaginatedGroups, selectPaginatedSelectGroups,
  selectGroupTotal, selectGroup, selectFormGroup
};
