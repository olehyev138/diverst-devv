import {
  GET_BUDGET_ITEM_BEGIN,
  GET_BUDGET_ITEM_SUCCESS,
  GET_BUDGET_ITEM_ERROR,
  GET_BUDGET_ITEMS_BEGIN,
  GET_BUDGET_ITEMS_SUCCESS,
  GET_BUDGET_ITEMS_ERROR,
  CLOSE_BUDGET_ITEM_SUCCESS,
  CLOSE_BUDGET_ITEM_BEGIN,
  CLOSE_BUDGET_ITEM_ERROR,
  BUDGET_ITEMS_UNMOUNT,
} from '../constants';

import {
  getBudgetItemBegin,
  getBudgetItemError,
  getBudgetItemSuccess,
  getBudgetItemsBegin,
  getBudgetItemsError,
  getBudgetItemsSuccess,
  closeBudgetItemsBegin,
  closeBudgetItemsError,
  closeBudgetItemsSuccess,
  budgetItemsUnmount
} from '../actions';

describe('outcome actions', () => {
  describe('getBudgetItemBegin', () => {
    it('has a type of GET_BUDGET_ITEM_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_ITEM_BEGIN,
        payload: { value: 118 }
      };

      expect(getBudgetItemBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetItemSuccess', () => {
    it('has a type of GET_BUDGET_ITEM_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_ITEM_SUCCESS,
        payload: { value: 865 }
      };

      expect(getBudgetItemSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getBudgetItemError', () => {
    it('has a type of GET_BUDGET_ITEM_ERROR and sets a given error', () => {
      const expected = {
        type: GET_BUDGET_ITEM_ERROR,
        error: { value: 709 }
      };

      expect(getBudgetItemError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getBudgetItemsBegin', () => {
    it('has a type of GET_BUDGET_ITEMS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_ITEMS_BEGIN,
        payload: { value: 118 }
      };

      expect(getBudgetItemsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetItemsSuccess', () => {
    it('has a type of GET_BUDGET_ITEMS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_ITEMS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getBudgetItemsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetItemsError', () => {
    it('has a type of GET_BUDGET_ITEMS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_BUDGET_ITEMS_ERROR,
        error: { value: 709 }
      };

      expect(getBudgetItemsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('closeBudgetItemsBegin', () => {
    it('has a type of CLOSE_BUDGET_ITEM_BEGIN and sets a given payload', () => {
      const expected = {
        type: CLOSE_BUDGET_ITEM_BEGIN,
        payload: { value: 118 }
      };

      expect(closeBudgetItemsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('closeBudgetItemsSuccess', () => {
    it('has a type of CLOSE_BUDGET_ITEM_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CLOSE_BUDGET_ITEM_SUCCESS,
        payload: { value: 118 }
      };

      expect(closeBudgetItemsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('closeBudgetItemsError', () => {
    it('has a type of CLOSE_BUDGET_ITEM_ERROR and sets a given error', () => {
      const expected = {
        type: CLOSE_BUDGET_ITEM_ERROR,
        error: { value: 709 }
      };

      expect(closeBudgetItemsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('BudgetItemsUnmount', () => {
    it('has a type of BUDGET_ITEMS_UNMOUNT', () => {
      const expected = {
        type: BUDGET_ITEMS_UNMOUNT,
      };

      expect(budgetItemsUnmount()).toEqual(expected);
    });
  });
});
