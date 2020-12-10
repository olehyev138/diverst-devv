/*
 *
 * BudgetUser reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_BUDGET_USERS_BEGIN,
  GET_BUDGET_USERS_SUCCESS,
  GET_BUDGET_USERS_ERROR,
  BUDGET_USERS_UNMOUNT,
} from './constants';
import {FINALIZE_EXPENSES_BEGIN, FINALIZE_EXPENSES_ERROR, FINALIZE_EXPENSES_SUCCESS} from "containers/Event/constants";

export const initialState = {
  budgetUserList: [],
  budgetUserListTotal: null,
  currentBudgetUser: null,
  isFetchingBudgetUsers: false,
  isFetchingBudgetUser: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function budgetUserReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_BUDGET_USERS_BEGIN:
        draft.isFetchingBudgetUsers = true;
        draft.hasChanged = false;
        break;

      case GET_BUDGET_USERS_SUCCESS:
        draft.budgetUserList = action.payload.items;
        draft.budgetUserListTotal = action.payload.total;
        draft.isFetchingBudgetUsers = false;
        break;

      case GET_BUDGET_USERS_ERROR:
        draft.isFetchingBudgetUsers = false;
        break;

      case FINALIZE_EXPENSES_BEGIN:
        draft.isCommitting = true;
        break;

      case FINALIZE_EXPENSES_ERROR:
        draft.isCommitting = false;
        break;

      case FINALIZE_EXPENSES_SUCCESS:
        draft.hasChanged = true;
        draft.isCommitting = false;
        break;

      case BUDGET_USERS_UNMOUNT:
        return initialState;
    }
  });
}
export default budgetUserReducer;
