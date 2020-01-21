/*
 *
 * Budget reducer
 *
 */

import produce from 'immer/dist/immer';
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
      case UPDATE_ANNUAL_BUDGET_BEGIN:
      case CREATE_BUDGET_BEGIN:
      case UPDATE_BUDGET_BEGIN:
      case DELETE_BUDGET_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case UPDATE_ANNUAL_BUDGET_SUCCESS:
      case CREATE_BUDGET_SUCCESS:
      case UPDATE_BUDGET_SUCCESS:
      case DELETE_BUDGET_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case UPDATE_ANNUAL_BUDGET_ERROR:
      case CREATE_BUDGET_ERROR:
      case UPDATE_BUDGET_ERROR:
      case DELETE_BUDGET_ERROR:

      case BUDGETS_UNMOUNT:
        return initialState;
    }
  });
}
export default budgetReducer;
