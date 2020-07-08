import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import { formatColor, mapFieldNames } from 'utils/selectorHelpers';

const selectGroupsDomain = state => state.groups || initialState;

const changeGroupColor = group => formatColor(group.calendar_color);

const selectPaginatedGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => groupsState.groupList
);

/* Select group list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */

const groupMapper = group => ({ value: group.id, label: group.name, logo_data: group.logo_data, children: (group.children || []).map(groupMapper) });

const selectPaginatedSelectGroups = () => createSelector(
  selectGroupsDomain,
  groupsState => (
    Object
      .values(groupsState.groupList)
      .map(groupMapper)
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
  selectGroupIsFormLoading,
  selectGroupIsCommitting,
  selectHasChanged,
  selectCategorizeGroup,
};
