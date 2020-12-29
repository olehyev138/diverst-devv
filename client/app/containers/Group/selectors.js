import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import { formatColor, mapFieldNames } from 'utils/selectorHelpers';
import produce from 'immer';

const selectGroupsDomain = state => state.groups || initialState;

const changeGroupColor = group => formatColor(group.calendar_color);

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList
);

/* Select group list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */

export const groupMapper = group => ({ value: group.id, label: group.name, logo_data: group.logo_data, is_parent_group: group.is_parent_group });

const selectPaginatedSelectGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => (
    Object
      .values(groupsState.groupList)
      .map(groupMapper)
  )
);

const selectColorGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupColorList
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

    const selectGroup = currentGroup;

    selectGroup.children = selectGroup.children.map(child => ({
      id: child.id,
      name: child.name,
      group_category_id: child.group_category ? child.group_category.id : null,
      group_category_type_id: child.group_category_type ? child.group_category_type.id : null,
      category: child.group_category ? { value: child.group_category.id, label: child.group_category.name } : null
    }));
    return selectGroup;
  }
);

const selectGroupIsLoading = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isLoading
);

const selectColorGroupsIsLoading = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.isColorGroupsLoading
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
    return produce(currentGroup, (draft) => {
      draft.children = currentGroup.children.map(child => ({
        value: child.id,
        label: child.name
      }));
      if (currentGroup.parent)
        draft.parent = {
          value: currentGroup.parent.id,
          label: currentGroup.parent.name
        };
    });
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
  selectColorGroups,
  selectGroupTotal,
  selectGroup,
  selectFormGroup,
  selectGroupIsLoading,
  selectColorGroupsIsLoading,
  selectGroupIsFormLoading,
  selectGroupIsCommitting,
  selectHasChanged,
  selectCategorizeGroup,
};
