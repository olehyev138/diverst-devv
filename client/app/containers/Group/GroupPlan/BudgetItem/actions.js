/*
 *
 * Budget_Item actions
 *
 */

import {
  GET_BUDGET_ITEM_BEGIN,
  GET_BUDGET_ITEM_SUCCESS,
  GET_BUDGET_ITEM_ERROR,
  GET_BUDGET_ITEMS_BEGIN,
  GET_BUDGET_ITEMS_SUCCESS,
  GET_BUDGET_ITEMS_ERROR,
  CLOSE_BUDGET_ITEM_BEGIN,
  CLOSE_BUDGET_ITEM_SUCCESS,
  CLOSE_BUDGET_ITEM_ERROR,
  BUDGET_ITEMS_UNMOUNT,
} from './constants';

export function getBudgetItemBegin(payload) {
  return {
    type: GET_BUDGET_ITEM_BEGIN,
    payload,
  };
}

export function getBudgetItemSuccess(payload) {
  return {
    type: GET_BUDGET_ITEM_SUCCESS,
    payload,
  };
}

export function getBudgetItemError(error) {
  return {
    type: GET_BUDGET_ITEM_ERROR,
    error,
  };
}

export function getBudgetItemsBegin(payload) {
  return {
    type: GET_BUDGET_ITEMS_BEGIN,
    payload,
  };
}

export function getBudgetItemsSuccess(payload) {
  return {
    type: GET_BUDGET_ITEMS_SUCCESS,
    payload,
  };
}

export function getBudgetItemsError(error) {
  return {
    type: GET_BUDGET_ITEMS_ERROR,
    error,
  };
}

export function closeBudgetItemsBegin(payload) {
  return {
    type: CLOSE_BUDGET_ITEM_BEGIN,
    payload,
  };
}

export function closeBudgetItemsSuccess(payload) {
  return {
    type: CLOSE_BUDGET_ITEM_SUCCESS,
    payload,
  };
}

export function closeBudgetItemsError(error) {
  return {
    type: CLOSE_BUDGET_ITEM_ERROR,
    error,
  };
}

export function budgetItemsUnmount(payload) {
  return {
    type: BUDGET_ITEMS_UNMOUNT,
    payload,
  };
}
