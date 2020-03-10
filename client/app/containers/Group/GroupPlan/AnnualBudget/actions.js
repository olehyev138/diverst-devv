/*
 *
 * AnnualBudget actions
 *
 */

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
} from './constants';

export function getCurrentAnnualBudgetBegin(payload) {
  return {
    type: GET_CURRENT_ANNUAL_BUDGET_BEGIN,
    payload,
  };
}

export function getCurrentAnnualBudgetSuccess(payload) {
  return {
    type: GET_CURRENT_ANNUAL_BUDGET_SUCCESS,
    payload,
  };
}

export function getCurrentAnnualBudgetError(error) {
  return {
    type: GET_CURRENT_ANNUAL_BUDGET_ERROR,
    error,
  };
}

export function getAnnualBudgetBegin(payload) {
  return {
    type: GET_ANNUAL_BUDGET_BEGIN,
    payload,
  };
}

export function getAnnualBudgetSuccess(payload) {
  return {
    type: GET_ANNUAL_BUDGET_SUCCESS,
    payload,
  };
}

export function getAnnualBudgetError(error) {
  return {
    type: GET_ANNUAL_BUDGET_ERROR,
    error,
  };
}

export function getAnnualBudgetsBegin(payload) {
  return {
    type: GET_ANNUAL_BUDGETS_BEGIN,
    payload,
  };
}

export function getAnnualBudgetsSuccess(payload) {
  return {
    type: GET_ANNUAL_BUDGETS_SUCCESS,
    payload,
  };
}

export function getAnnualBudgetsError(error) {
  return {
    type: GET_ANNUAL_BUDGETS_ERROR,
    error,
  };
}

export function createAnnualBudgetBegin(payload) {
  return {
    type: CREATE_ANNUAL_BUDGET_BEGIN,
    payload,
  };
}

export function createAnnualBudgetSuccess(payload) {
  return {
    type: CREATE_ANNUAL_BUDGET_SUCCESS,
    payload,
  };
}

export function createAnnualBudgetError(error) {
  return {
    type: CREATE_ANNUAL_BUDGET_ERROR,
    error,
  };
}

export function updateAnnualBudgetBegin(payload) {
  return {
    type: UPDATE_ANNUAL_BUDGET_BEGIN,
    payload,
  };
}

export function updateAnnualBudgetSuccess(payload) {
  return {
    type: UPDATE_ANNUAL_BUDGET_SUCCESS,
    payload,
  };
}

export function updateAnnualBudgetError(error) {
  return {
    type: UPDATE_ANNUAL_BUDGET_ERROR,
    error,
  };
}

export function annualBudgetsUnmount(payload) {
  return {
    type: ANNUAL_BUDGETS_UNMOUNT,
    payload,
  };
}
