import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectGroupsDomain = state => state.groups || initialState;

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList
);

/* Select group list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
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

const selectGroupIsLoading = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isFormLoading
);

const selectGroupIsCommitting = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isCommitting
);

const selectFormGroup = () => createSelector(
  selectGroupsDomain,
  (groupsState) => {
    const { currentGroup } = groupsState;
    if (!currentGroup) return null;

    // clone group before making mutations on it
    const selectGroup = Object.assign({}, currentGroup);

    selectGroup.children = selectGroup.children.map(child => ({
      value: child.id,
      label: child.name
    }));

    return selectGroup;
  }
);
const selectHasChanged = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.hasChanged
);

export {
  selectGroupsDomain,
  selectPaginatedSelectGroups,
  selectPaginatedGroups,
  selectGroupTotal,
  selectGroup,
  selectFormGroup,
  selectGroupIsLoading,
  selectIsFormLoading,
  selectGroupIsCommitting,
  selectHasChanged,
};
