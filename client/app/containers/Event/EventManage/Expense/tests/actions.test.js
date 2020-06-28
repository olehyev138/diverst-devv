import {
  GET_EXPENSE_BEGIN,
  GET_EXPENSE_SUCCESS,
  GET_EXPENSE_ERROR,
  GET_EXPENSES_BEGIN,
  GET_EXPENSES_SUCCESS,
  GET_EXPENSES_ERROR,
  CREATE_EXPENSE_BEGIN,
  CREATE_EXPENSE_SUCCESS,
  CREATE_EXPENSE_ERROR,
  UPDATE_EXPENSE_BEGIN,
  UPDATE_EXPENSE_SUCCESS,
  UPDATE_EXPENSE_ERROR,
  DELETE_EXPENSE_BEGIN,
  DELETE_EXPENSE_SUCCESS,
  DELETE_EXPENSE_ERROR,
  EXPENSES_UNMOUNT,
} from '../constants';

import {
  getExpenseBegin,
  getExpenseError,
  getExpenseSuccess,
  getExpensesBegin,
  getExpensesError,
  getExpensesSuccess,
  createExpenseBegin,
  createExpenseError,
  createExpenseSuccess,
  updateExpenseBegin,
  updateExpenseError,
  updateExpenseSuccess,
  deleteExpenseBegin,
  deleteExpenseError,
  deleteExpenseSuccess,
  expensesUnmount
} from '../actions';

describe('expense actions', () => {
  describe('getExpenseBegin', () => {
    it('has a type of GET_EXPENSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_EXPENSE_BEGIN,
        payload: { value: 118 }
      };

      expect(getExpenseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getExpenseSuccess', () => {
    it('has a type of GET_EXPENSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_EXPENSE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getExpenseSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getExpenseError', () => {
    it('has a type of GET_EXPENSE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_EXPENSE_ERROR,
        error: { value: 709 }
      };

      expect(getExpenseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getExpensesBegin', () => {
    it('has a type of GET_EXPENSES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_EXPENSES_BEGIN,
        payload: { value: 118 }
      };

      expect(getExpensesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getExpensesSuccess', () => {
    it('has a type of GET_EXPENSES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_EXPENSES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getExpensesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getExpensesError', () => {
    it('has a type of GET_EXPENSES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_EXPENSES_ERROR,
        error: { value: 709 }
      };

      expect(getExpensesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createExpenseBegin', () => {
    it('has a type of CREATE_EXPENSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_EXPENSE_BEGIN,
        payload: { value: 118 }
      };

      expect(createExpenseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createExpenseSuccess', () => {
    it('has a type of CREATE_EXPENSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_EXPENSE_SUCCESS,
        payload: { value: 118 }
      };

      expect(createExpenseSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createExpenseError', () => {
    it('has a type of CREATE_EXPENSE_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_EXPENSE_ERROR,
        error: { value: 709 }
      };

      expect(createExpenseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateExpenseBegin', () => {
    it('has a type of UPDATE_EXPENSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_EXPENSE_BEGIN,
        payload: { value: 118 }
      };

      expect(updateExpenseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateExpenseSuccess', () => {
    it('has a type of UPDATE_EXPENSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_EXPENSE_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateExpenseSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateExpenseError', () => {
    it('has a type of UPDATE_EXPENSE_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_EXPENSE_ERROR,
        error: { value: 709 }
      };

      expect(updateExpenseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteExpenseBegin', () => {
    it('has a type of DELETE_EXPENSE_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_EXPENSE_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteExpenseBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteExpenseSuccess', () => {
    it('has a type of DELETE_EXPENSE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_EXPENSE_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteExpenseSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteExpenseError', () => {
    it('has a type of DELETE_EXPENSE_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_EXPENSE_ERROR,
        error: { value: 709 }
      };

      expect(deleteExpenseError({ value: 709 })).toEqual(expected);
    });
  });

  describe('expensesUnmount', () => {
    it('has a type of EXPENSES_UNMOUNT', () => {
      const expected = {
        type: EXPENSES_UNMOUNT,
      };

      expect(expensesUnmount()).toEqual(expected);
    });
  });
});
