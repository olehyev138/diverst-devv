import { createSelector } from 'reselect/lib/index';
import { initialState } from 'containers/Group/GroupCategories/reducer';

const selectGroupCategoriesDomain = state => state.groupCategories || initialState;

const selectPaginatedGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.groupCategoriesList
);

/* Select group list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => (
    Object
      .values(groupCategoriesState.groupCategoriesList)
      .map(group => ({ value: group.id, label: group.name }))
  )
);

const selectGroupCategoriesTotal = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.groupTotal
);

const selectGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.currentGroup
);

const selectGroupCategoriesIsLoading = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.isLoading
);

const selectGroupCategoriesIsFormLoading = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.isFormLoading
);

const selectGroupCategoriesIsCommitting = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.isCommitting
);

const selectFormGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  (groupCategoriesState) => {
    const { currentGroup } = groupCategoriesState;
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
  selectGroupCategoriesDomain, selectPaginatedGroupCategories, selectPaginatedSelectGroupCategories,
  selectGroupCategoriesTotal, selectGroupCategories, selectFormGroupCategories, selectGroupCategoriesIsLoading,
  selectGroupCategoriesIsCommitting, selectGroupCategoriesIsFormLoading
};
