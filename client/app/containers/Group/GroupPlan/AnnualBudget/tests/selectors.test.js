import {
  selectAnnualBudgetDomain,
  selectPaginatedAnnualBudgets,
  selectPaginatedInitiatives,
  selectInitiativesTotal,
  selectAnnualBudgetsTotal,
  selectAnnualBudget,
  selectIsFetchingAnnualBudgets,
  selectIsFetchingAnnualBudget,
  selectIsFetchingInitiatives,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';

describe('AnnualBudget selectors', () => {
  describe('selectAnnualBudgetDomain', () => {
    it('should select the metrics domain', () => {
      const mockedState = {};
      const selected = selectAnnualBudgetDomain(mockedState);

      expect(selected).toEqual({ ...initialState });
    });

    it('should select initialState', () => {
      const mockedState = {};
      const selected = selectAnnualBudgetDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectPaginatedAnnualBudgets', () => {
    it('should return the selected item', () => {
      const mockedState = { annualBudgetList: [] };
      const selected = selectPaginatedAnnualBudgets().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectAnnualBudgetsTotal', () => {
    it('should select the annualBudget total', () => {
      const mockedState = { annualBudgetListTotal: 84 };
      const selected = selectAnnualBudgetsTotal().resultFunc(mockedState);

      expect(selected).toEqual(84);
    });
  });

  describe('selectPaginatedInitiatives', () => {
    it('should return the selected item', () => {
      const mockedState = { annualBudgetInitiativeList: [] };
      const selected = selectPaginatedInitiatives().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectInitiativesTotal', () => {
    it('should select the initiatives total', () => {
      const mockedState = { annualBudgetInitiativeListTotal: 84 };
      const selected = selectInitiativesTotal().resultFunc(mockedState);

      expect(selected).toEqual(84);
    });
  });

  describe('selectIsFetchingInitiatives', () => {
    it('should select the \'isFetchingAnnualBudgetInitiatives\' flag', () => {
      const mockedState = { isFetchingAnnualBudgetInitiatives: true };
      const selected = selectIsFetchingInitiatives().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectAnnualBudget', () => {
    it('should return the selected item', () => {
      const mockedState = { currentAnnualBudget: {} };
      const selected = selectAnnualBudget().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectIsFetchingAnnualBudget', () => {
    it('should select the \'isFetchingAnnualBudget\' flag', () => {
      const mockedState = { isFetchingAnnualBudget: true };
      const selected = selectIsFetchingAnnualBudget().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingAnnualBudgets', () => {
    it('should select the \'isFetchingAnnualBudgest\' flag', () => {
      const mockedState = { isFetchingAnnualBudgets: true };
      const selected = selectIsFetchingAnnualBudgets().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'isCommitting\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'hasChanged\' flag', () => {
      const mockedState = { hasChanged: true };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });
});
