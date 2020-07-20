import { createSelector } from 'reselect';
import { initialState } from 'containers/Group/GroupCategories/reducer';

const selectGroupCategoriesDomain = state => state.groupCategories || initialState;

const selectPaginatedGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.groupCategoriesList
);

const selectPaginatedSelectGroupCategories = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => (
    Object
      .values(groupCategoriesState.groupCategoriesList)
      .flatMap(groupCategory => groupCategory.group_categories.map(gc => ({ value: gc.id, label: gc.name })))
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

const selectIsLoading = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.isLoading
);

const selectIsFormLoading = () => createSelector(
  selectGroupCategoriesDomain,
  groupCategoriesState => groupCategoriesState.isFormLoading
);

const selectIsCommitting = () => createSelector(
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
  selectGroupCategoriesTotal, selectGroupCategories, selectFormGroupCategories, selectIsLoading,
  selectIsCommitting, selectIsFormLoading
};
