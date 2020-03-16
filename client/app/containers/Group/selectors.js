import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/reducer';

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

const selectCategorizeGroup = () => createSelector(
  selectGroupsDomain,
  (groupsState) => {
    const { currentGroup } = groupsState;
    if (!currentGroup) return null;

    const selectGroup = {
      ...groupsState.currentGroup, ...{
        name: {
          label: groupsState.currentGroup.name,
          value: groupsState.currentGroup.id
        }
      }
    };

    selectGroup.children = selectGroup.children.map(child => ({
      id: child.id,
      name: child.name,
      group_category_id: child.group_category,
      group_category_type_id: child.group_category_type
    }));

    return selectGroup;
  }
);

const selectGroupIsLoading = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isLoading
);

const selectGroupIsFormLoading = () => createSelector(
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

export {
  selectGroupsDomain, selectPaginatedGroups, selectPaginatedSelectGroups,
  selectGroupTotal, selectGroup, selectFormGroup, selectGroupIsLoading,
  selectGroupIsCommitting, selectGroupIsFormLoading, selectCategorizeGroup
};
