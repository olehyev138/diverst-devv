/*
 *
 * BudgetUser actions
 *
 */

import {
  GET_BUDGET_USERS_BEGIN,
  GET_BUDGET_USERS_SUCCESS,
  GET_BUDGET_USERS_ERROR,
  FINALIZE_EXPENSES_BEGIN,
  FINALIZE_EXPENSES_ERROR,
  FINALIZE_EXPENSES_SUCCESS,
  BUDGET_USERS_UNMOUNT,
} from './constants';

export function getBudgetUsersBegin(payload) {
  return {
    type: GET_BUDGET_USERS_BEGIN,
    payload,
  };
}

export function getBudgetUsersSuccess(payload) {
  return {
    type: GET_BUDGET_USERS_SUCCESS,
    payload,
  };
}

export function getBudgetUsersError(error) {
  return {
    type: GET_BUDGET_USERS_ERROR,
    error,
  };
}

export function budgetUsersUnmount(payload) {
  return {
    type: BUDGET_USERS_UNMOUNT,
    payload,
  };
}

export function finalizeExpensesBegin(payload) {
  return {
    type: FINALIZE_EXPENSES_BEGIN,
    payload,
  };
}

export function finalizeExpensesSuccess(payload) {
  return {
    type: FINALIZE_EXPENSES_SUCCESS,
    payload,
  };
}

export function finalizeExpensesError(error) {
  return {
    type: FINALIZE_EXPENSES_ERROR,
    error,
  };
}
