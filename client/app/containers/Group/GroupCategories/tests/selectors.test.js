import {
  selectGroupCategoriesDomain, selectPaginatedGroupCategories,
  selectPaginatedSelectGroupCategories,
  selectGroupCategoriesTotal, selectGroupCategories,
  selectFormGroupCategories, selectIsLoading,
  selectIsCommitting, selectIsFormLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('GroupCategory selectors', () => {
  describe('selectGroupCategoryDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { groupCategories: { groupCategory: {} } };
      const selected = selectGroupCategoriesDomain(mockedState);

      expect(selected).toEqual({ groupCategory: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectGroupCategoriesDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsLoading', () => {
    it('should select the \'is loading\' flag', () => {
      const mockedState = { isLoading: true };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is formloading\' flag', () => {
      const mockedState = { isFormLoading: true };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectGroupCategoriesTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { groupCategoriesTotal: 289 };
      const selected = selectGroupCategoriesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectGroupCategory', () => {
    it('should select the currentGroupCategory', () => {
      const mockedState = { currentGroup: { id: 374, __dummy: '374' } };
      const selected = selectGroupCategories().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedGroupCategories', () => {
    it('should select the paginated groupCategories', () => {
      const mockedState = { groupCategoriesList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedGroupCategories().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectPaginatedSelectGroupCategories', () => {
    it('should select the paginated groupCategories', () => {
      const mockedState = { groupCategoriesList: [{ id: 37, name: 'dummy', group_categories: [{ id: 37, name: 'dummy' }] }] };
      const selected = selectPaginatedSelectGroupCategories().resultFunc(mockedState);

      expect(selected).toEqual([{ label: 'dummy', value: 37 }]);
    });
  });

  describe('selectFormGroupCategory', () => {
    it('returns null', () => {
      const mockedState = { currentGroup: { id: 374, __dummy: '374' } };
      const selected = selectFormGroupCategories().resultFunc(mockedState);

      expect(selected).toEqual(null);
    });
  });

  it('should select currentGroupCategory and do more stuff', () => {
    const mockedState = { currentGroupCategory: { id: 374, __dummy: '374', group_categories: [] } };
    const selected = selectFormGroupCategories().resultFunc(mockedState);

    expect(selected).toEqual({ id: 374, __dummy: '374', group_categories: [] });
  });
});
