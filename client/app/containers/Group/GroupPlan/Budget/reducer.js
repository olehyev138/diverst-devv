/*
 *
 * Budget reducer
 *
 */

import produce from 'immer/dist/immer';
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
} from './constants';

export const initialState = {
  budgetList: [],
  budgetListTotal: null,
  currentBudget: null,
  isFetchingBudgets: false,
  isFetchingBudget: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function budgetReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_BUDGET_BEGIN:
        draft.isFetchingBudget = true;
        break;

      case GET_BUDGET_SUCCESS:
        draft.currentBudget = action.payload.budget;
        draft.isFetchingBudget = false;
        break;

      case GET_BUDGET_ERROR:
        draft.isFetchingBudget = false;
        break;

      case GET_BUDGETS_BEGIN:
        draft.isFetchingBudgets = true;
        draft.hasChanged = false;
        break;

      case GET_BUDGETS_SUCCESS:
        draft.budgetList = action.payload.items;
        draft.budgetListTotal = action.payload.total;
        draft.isFetchingBudgets = false;
        break;

      case GET_BUDGETS_ERROR:
        draft.isFetchingBudgets = false;
        break;

      case CREATE_BUDGET_REQUEST_BEGIN:
      case APPROVE_BUDGET_BEGIN:
      case DECLINE_BUDGET_BEGIN:
      case DELETE_BUDGET_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_BUDGET_REQUEST_SUCCESS:
      case APPROVE_BUDGET_SUCCESS:
      case DECLINE_BUDGET_SUCCESS:
      case DELETE_BUDGET_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_BUDGET_REQUEST_ERROR:
      case APPROVE_BUDGET_ERROR:
      case DECLINE_BUDGET_ERROR:
      case DELETE_BUDGET_ERROR:
        draft.isCommitting = false;
        break;

      case BUDGETS_UNMOUNT:
        return initialState;
    }
  });
}
export default budgetReducer;
