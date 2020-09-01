import {
  GET_BUDGET_BEGIN,
  GET_BUDGET_SUCCESS,
  GET_BUDGET_ERROR,
  GET_BUDGETS_BEGIN,
  GET_BUDGETS_SUCCESS,
  GET_BUDGETS_ERROR,
  CREATE_BUDGET_REQUEST_BEGIN,
  CREATE_BUDGET_REQUEST_SUCCESS,
  CREATE_BUDGET_REQUEST_ERROR,
  APPROVE_BUDGET_BEGIN,
  APPROVE_BUDGET_SUCCESS,
  APPROVE_BUDGET_ERROR,
  DECLINE_BUDGET_BEGIN,
  DECLINE_BUDGET_SUCCESS,
  DECLINE_BUDGET_ERROR,
  DELETE_BUDGET_BEGIN,
  DELETE_BUDGET_SUCCESS,
  DELETE_BUDGET_ERROR,
  BUDGETS_UNMOUNT,
} from '../constants';

import {
  getBudgetSuccess, getBudgetError, getBudgetBegin,
  getBudgetsSuccess, getBudgetsError, getBudgetsBegin,
  createBudgetRequestSuccess, createBudgetRequestError, createBudgetRequestBegin,
  approveBudgetSuccess, approveBudgetError, approveBudgetBegin,
  declineBudgetSuccess, declineBudgetError, declineBudgetBegin,
  deleteBudgetSuccess, deleteBudgetError, deleteBudgetBegin,
  budgetsUnmount
} from '../actions';

describe('Budget actions', () => {
  describe('getBudgetBegin', () => {
    it('has a type of GET_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(getBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetSuccess', () => {
    it('has a type of GET_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_BUDGET_SUCCESS,
        payload: { value: 865 }
      };

      expect(getBudgetSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getBudgetError', () => {
    it('has a type of GET_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: GET_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(getBudgetError({ value: 709 })).toEqual(expected);
    });
  });
  describe('getBudgetsBegin', () => {
    it('has a type of GET_BUDGETS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_BUDGETS_BEGIN,
        payload: { value: 118 }
      };

      expect(getBudgetsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetsSuccess', () => {
    it('has a type of GET_BUDGETS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_BUDGETS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getBudgetsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getBudgetsError', () => {
    it('has a type of GET_BUDGETS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_BUDGETS_ERROR,
        error: { value: 709 }
      };

      expect(getBudgetsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createBudgetRequestBegin', () => {
    it('has a type of CREATE_BUDGET_REQUEST_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_BUDGET_REQUEST_BEGIN,
        payload: { value: 118 }
      };

      expect(createBudgetRequestBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createBudgetRequestSuccess', () => {
    it('has a type of CREATE_BUDGET_REQUEST_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_BUDGET_REQUEST_SUCCESS,
        payload: { value: 118 }
      };

      expect(createBudgetRequestSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createBudgetRequestError', () => {
    it('has a type of CREATE_BUDGET_REQUEST_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_BUDGET_REQUEST_ERROR,
        error: { value: 709 }
      };

      expect(createBudgetRequestError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteBudgetBegin', () => {
    it('has a type of DELETE_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteBudgetSuccess', () => {
    it('has a type of DELETE_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_BUDGET_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteBudgetSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteBudgetError', () => {
    it('has a type of DELETE_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(deleteBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('approveBudgetBegin', () => {
    it('has a type of APPROVE_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: APPROVE_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(approveBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('approveBudgetSuccess', () => {
    it('has a type of APPROVE_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: APPROVE_BUDGET_SUCCESS,
        payload: { value: 118 }
      };

      expect(approveBudgetSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('approveBudgetError', () => {
    it('has a type of APPROVE_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: APPROVE_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(approveBudgetError({ value: 709 })).toEqual(expected);
    });
  });


  describe('declineBudgetBegin', () => {
    it('has a type of DECLINE_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: DECLINE_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(declineBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('declineBudgetSuccess', () => {
    it('has a type of DECLINE_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DECLINE_BUDGET_SUCCESS,
        payload: { value: 118 }
      };

      expect(declineBudgetSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('declineBudgetError', () => {
    it('has a type of DECLINE_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: DECLINE_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(declineBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('budgetsUnmount', () => {
    it('has a type of BUDGETS_UNMOUNT', () => {
      const expected = {
        type: BUDGETS_UNMOUNT,
      };

      expect(budgetsUnmount()).toEqual(expected);
    });
  });
});
