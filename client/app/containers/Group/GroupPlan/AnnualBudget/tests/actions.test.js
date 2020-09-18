import {
  GET_CURRENT_ANNUAL_BUDGET_BEGIN,
  GET_CURRENT_ANNUAL_BUDGET_SUCCESS,
  GET_CURRENT_ANNUAL_BUDGET_ERROR,
  GET_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGET_SUCCESS,
  GET_ANNUAL_BUDGET_ERROR,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_ANNUAL_BUDGETS_SUCCESS,
  GET_ANNUAL_BUDGETS_ERROR,
  CREATE_ANNUAL_BUDGET_BEGIN,
  CREATE_ANNUAL_BUDGET_SUCCESS,
  CREATE_ANNUAL_BUDGET_ERROR,
  UPDATE_ANNUAL_BUDGET_BEGIN,
  UPDATE_ANNUAL_BUDGET_SUCCESS,
  UPDATE_ANNUAL_BUDGET_ERROR,
  ANNUAL_BUDGETS_UNMOUNT,
} from '../constants';

import {
  getAnnualBudgetBegin,
  getAnnualBudgetError,
  getAnnualBudgetSuccess,
  getAnnualBudgetsBegin,
  getAnnualBudgetsError,
  getAnnualBudgetsSuccess,
  createAnnualBudgetBegin,
  createAnnualBudgetError,
  createAnnualBudgetSuccess,
  updateAnnualBudgetBegin,
  updateAnnualBudgetError,
  updateAnnualBudgetSuccess,
  getCurrentAnnualBudgetBegin,
  getCurrentAnnualBudgetError,
  getCurrentAnnualBudgetSuccess,
  annualBudgetsUnmount
} from '../actions';

describe('annualBudget actions', () => {
  describe('getCurrentAnnualBudgetBegin', () => {
    it('has a type of GET_CURRENT_ANNUAL_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_CURRENT_ANNUAL_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(getCurrentAnnualBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getCurrentAnnualBudgetSuccess', () => {
    it('has a type of GET_ANNUAL_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_CURRENT_ANNUAL_BUDGET_SUCCESS,
        payload: { value: 865 }
      };

      expect(getCurrentAnnualBudgetSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getCurrentAnnualBudgetError', () => {
    it('has a type of GET_CURRENT_ANNUAL_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: GET_CURRENT_ANNUAL_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(getCurrentAnnualBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetBegin', () => {
    it('has a type of GET_ANNUAL_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_ANNUAL_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(getAnnualBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetSuccess', () => {
    it('has a type of GET_ANNUAL_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_ANNUAL_BUDGET_SUCCESS,
        payload: { value: 865 }
      };

      expect(getAnnualBudgetSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetError', () => {
    it('has a type of GET_ANNUAL_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: GET_ANNUAL_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(getAnnualBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetsBegin', () => {
    it('has a type of GET_ANNUAL_BUDGETS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_ANNUAL_BUDGETS_BEGIN,
        payload: { value: 118 }
      };

      expect(getAnnualBudgetsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetsSuccess', () => {
    it('has a type of GET_ANNUAL_BUDGETS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_ANNUAL_BUDGETS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getAnnualBudgetsSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getAnnualBudgetsError', () => {
    it('has a type of GET_ANNUAL_BUDGETS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_ANNUAL_BUDGETS_ERROR,
        error: { value: 709 }
      };

      expect(getAnnualBudgetsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createAnnualBudgetBegin', () => {
    it('has a type of CREATE_ANNUAL_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_ANNUAL_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(createAnnualBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createAnnualBudgetSuccess', () => {
    it('has a type of CREATE_ANNUAL_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_ANNUAL_BUDGET_SUCCESS,
        payload: { value: 118 }
      };

      expect(createAnnualBudgetSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createAnnualBudgetError', () => {
    it('has a type of CREATE_ANNUAL_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_ANNUAL_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(createAnnualBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateAnnualBudgetBegin', () => {
    it('has a type of UPDATE_ANNUAL_BUDGET_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_ANNUAL_BUDGET_BEGIN,
        payload: { value: 118 }
      };

      expect(updateAnnualBudgetBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateAnnualBudgetSuccess', () => {
    it('has a type of UPDATE_ANNUAL_BUDGET_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_ANNUAL_BUDGET_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateAnnualBudgetSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateAnnualBudgetError', () => {
    it('has a type of UPDATE_ANNUAL_BUDGET_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_ANNUAL_BUDGET_ERROR,
        error: { value: 709 }
      };

      expect(updateAnnualBudgetError({ value: 709 })).toEqual(expected);
    });
  });

  describe('annualBudgetsUnmount', () => {
    it('has a type of ANNUAL_BUDGETS_UNMOUNT', () => {
      const expected = {
        type: ANNUAL_BUDGETS_UNMOUNT,
      };

      expect(annualBudgetsUnmount()).toEqual(expected);
    });
  });
});
