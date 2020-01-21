/*
 *
 * Budget actions
 *
 */

import {
  UPDATE_ANNUAL_BUDGET_BEGIN,
  UPDATE_ANNUAL_BUDGET_SUCCESS,
  UPDATE_ANNUAL_BUDGET_ERROR,
  CREATE_BUDGET_BEGIN,
  CREATE_BUDGET_SUCCESS,
  CREATE_BUDGET_ERROR,
  UPDATE_BUDGET_BEGIN,
  UPDATE_BUDGET_SUCCESS,
  UPDATE_BUDGET_ERROR,
  DELETE_BUDGET_BEGIN,
  DELETE_BUDGET_SUCCESS,
  DELETE_BUDGET_ERROR,
  BUDGETS_UNMOUNT,
} from './constants';

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

export function createBudgetBegin(payload) {
  return {
    type: CREATE_BUDGET_BEGIN,
    payload,
  };
}

export function createBudgetSuccess(payload) {
  return {
    type: CREATE_BUDGET_SUCCESS,
    payload,
  };
}

export function createBudgetError(error) {
  return {
    type: CREATE_BUDGET_ERROR,
    error,
  };
}

export function updateBudgetBegin(payload) {
  return {
    type: UPDATE_BUDGET_BEGIN,
    payload,
  };
}

export function updateBudgetSuccess(payload) {
  return {
    type: UPDATE_BUDGET_SUCCESS,
    payload,
  };
}

export function updateBudgetError(error) {
  return {
    type: UPDATE_BUDGET_ERROR,
    error,
  };
}

export function deleteBudgetBegin(payload) {
  return {
    type: DELETE_BUDGET_BEGIN,
    payload,
  };
}

export function deleteBudgetSuccess(payload) {
  return {
    type: DELETE_BUDGET_SUCCESS,
    payload,
  };
}

export function deleteBudgetError(error) {
  return {
    type: DELETE_BUDGET_ERROR,
    error,
  };
}

export function budgetsUnmount(payload) {
  return {
    type: BUDGETS_UNMOUNT,
    payload,
  };
}
