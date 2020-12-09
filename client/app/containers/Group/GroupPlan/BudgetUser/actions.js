/*
 *
 * BudgetUser actions
 *
 */

import {
  GET_BUDGET_USERS_BEGIN,
  GET_BUDGET_USERS_SUCCESS,
  GET_BUDGET_USERS_ERROR,
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
