import produce from 'immer';
import {
  getGroupCategoriesSuccess,
  getGroupCategorySuccess
} from 'containers/Group/GroupCategories/actions';
import groupCategoriesReducer from 'containers/Group/GroupCategories/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('groupCategoryReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isFormLoading: true,
      isCommitting: false,
      groupCategoriesList: {},
      groupTotal: null,
      currentGroup: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(groupCategoriesReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getGroupCategoriesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.groupCategoriesList = { 4: { id: 4, name: 'dummy' }};
      draft.groupCategoriesTotal = 31;
      draft.isLoading = false;
    });

    expect(
      groupCategoriesReducer(
        state,
        getGroupCategoriesSuccess({
          items: [{ id: 4, name: 'dummy' }],
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupCategorySuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentGroupCategory = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      groupCategoriesReducer(
        state,
        getGroupCategorySuccess({
          group_category_type: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
