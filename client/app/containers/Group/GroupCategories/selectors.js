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
      .map(groupCategory => ({ value: groupCategory.id, label: groupCategory.name }))
  )
);

const selectGroupCategoriesTotal = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.groupCategoriesTotal
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
    const { currentGroupCategory } = groupCategoriesState;
    if (!currentGroupCategory) return null;

    // clone group before making mutations on it
    const selectGroupCategory = Object.assign({}, currentGroupCategory);

    selectGroupCategory.group_categories = selectGroupCategory.group_categories.map(child => ({ name: child.name, id: child.id, _destroy: false }));

    return selectGroupCategory;
  }
);

export {
  selectGroupCategoriesDomain, selectPaginatedGroupCategories, selectPaginatedSelectGroupCategories,
  selectGroupCategoriesTotal, selectGroupCategories, selectFormGroupCategories, selectGroupCategoriesIsLoading,
  selectGroupCategoriesIsCommitting, selectGroupCategoriesIsFormLoading
};
