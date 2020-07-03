import {
  selectExpenseDomain,
  selectPaginatedExpenses,
  selectExpensesTotal,
  selectExpense,
  selectIsFetchingExpenses,
  selectIsFetchingExpense,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';

describe('Expense selectors', () => {
  describe('selectExpenseDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { expenses: { expense: {} } };
      const selected = selectExpenseDomain(mockedState);

      expect(selected).toEqual({ expense: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectExpenseDomain(mockedState);

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

  describe('selectExpensesTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { expenseListTotal: 289 };
      const selected = selectExpensesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingExpense', () => {
    it('should select the \'is fetchingExpense\' flag', () => {
      const mockedState = { isFetchingExpense: true };
      const selected = selectIsFetchingExpense().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingExpenses', () => {
    it('should select the \'is fetchingExpenses\' flag', () => {
      const mockedState = { isFetchingExpenses: true };
      const selected = selectIsFetchingExpenses().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectExpense', () => {
    it('should select the currentExpense', () => {
      const mockedState = { currentExpense: { id: 374, __dummy: '374' } };
      const selected = selectExpense().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedExpenses', () => {
    it('should select the paginated expenses', () => {
      const mockedState = { expenseList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedExpenses().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectExpense', () => {
    it('should select currentExpense and do more stuff', () => {
      const mockedState = { currentExpense: { id: 374, __dummy: '374' } };
      const selected = selectExpense().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });
});
