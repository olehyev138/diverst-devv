import {
  selectBudgetItemDomain,
  selectPaginatedBudgetItems,
  selectBudgetItemsTotal,
  selectBudgetItem,
  selectIsFetchingBudgetItems,
  selectIsFetchingBudgetItem,
  selectIsCommitting,
  selectHasChanged,
  selectPaginatedSelectBudgetItems
} from '../selectors';

import { initialState } from '../reducer';

describe('BudgetItem selectors', () => {
  describe('selectBudgetItemDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { budgetItems: { budgetItem: {} } };
      const selected = selectBudgetItemDomain(mockedState);

      expect(selected).toEqual({ budgetItem: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectBudgetItemDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectBudgetItemsTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { budgetItemListTotal: 289 };
      const selected = selectBudgetItemsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingBudgetItem', () => {
    it('should select the \'is fetchingBudgetItem\' flag', () => {
      const mockedState = { isFetchingBudgetItem: true };
      const selected = selectIsFetchingBudgetItem().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingBudgetItems', () => {
    it('should select the \'is fetchingBudgetItems\' flag', () => {
      const mockedState = { isFetchingBudgetItems: true };
      const selected = selectIsFetchingBudgetItems().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectBudgetItem', () => {
    it('should select the currentBudgetItem', () => {
      const mockedState = { currentBudgetItem: { id: 374, __dummy: '374' } };
      const selected = selectBudgetItem().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedBudgetItems', () => {
    it('should select the paginated budgetItems', () => {
      const mockedState = { budgetItemList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedBudgetItems().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectPaginatedSelectBudgetItems', () => {
    it('should select the paginated budgetItems', () => {
      const mockedState = { budgetItemList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedSelectBudgetItems().resultFunc(mockedState);

      expect(selected).toEqual([{ available: undefined, label: undefined, value: 37 }]);
    });
  });
});
