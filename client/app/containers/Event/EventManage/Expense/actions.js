/*
 *
 * Expense actions
 *
 */

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
} from './constants';

export function getExpenseBegin(payload) {
  return {
    type: GET_EXPENSE_BEGIN,
    payload,
  };
}

export function getExpenseSuccess(payload) {
  return {
    type: GET_EXPENSE_SUCCESS,
    payload,
  };
}

export function getExpenseError(error) {
  return {
    type: GET_EXPENSE_ERROR,
    error,
  };
}

export function getExpensesBegin(payload) {
  return {
    type: GET_EXPENSES_BEGIN,
    payload,
  };
}

export function getExpensesSuccess(payload) {
  return {
    type: GET_EXPENSES_SUCCESS,
    payload,
  };
}

export function getExpensesError(error) {
  return {
    type: GET_EXPENSES_ERROR,
    error,
  };
}

export function createExpenseBegin(payload) {
  return {
    type: CREATE_EXPENSE_BEGIN,
    payload,
  };
}

export function createExpenseSuccess(payload) {
  return {
    type: CREATE_EXPENSE_SUCCESS,
    payload,
  };
}

export function createExpenseError(error) {
  return {
    type: CREATE_EXPENSE_ERROR,
    error,
  };
}

export function updateExpenseBegin(payload) {
  return {
    type: UPDATE_EXPENSE_BEGIN,
    payload,
  };
}

export function updateExpenseSuccess(payload) {
  return {
    type: UPDATE_EXPENSE_SUCCESS,
    payload,
  };
}

export function updateExpenseError(error) {
  return {
    type: UPDATE_EXPENSE_ERROR,
    error,
  };
}

export function deleteExpenseBegin(payload) {
  return {
    type: DELETE_EXPENSE_BEGIN,
    payload,
  };
}

export function deleteExpenseSuccess(payload) {
  return {
    type: DELETE_EXPENSE_SUCCESS,
    payload,
  };
}

export function deleteExpenseError(error) {
  return {
    type: DELETE_EXPENSE_ERROR,
    error,
  };
}

export function expensesUnmount(payload) {
  return {
    type: EXPENSES_UNMOUNT,
    payload,
  };
}
