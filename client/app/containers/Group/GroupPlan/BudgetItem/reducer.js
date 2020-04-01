/*
 *
 * BudgetItem reducer
 *
 */

import produce from 'immer/dist/immer';
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

export const initialState = {
  budgetItemList: [],
  budgetItemListTotal: null,
  currentBudgetItem: null,
  isFetchingBudgetItems: true,
  isFetchingBudgetItem: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function budgetItemReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_BUDGET_ITEM_BEGIN:
        draft.isFetchingBudgetItem = true;
        break;

      case GET_BUDGET_ITEM_SUCCESS:
        draft.currentBudgetItem = action.payload.budget_item;
        draft.isFetchingBudgetItem = false;
        break;

      case GET_BUDGET_ITEM_ERROR:
        draft.isFetchingBudgetItem = false;
        break;

      case GET_BUDGET_ITEMS_BEGIN:
        draft.isFetchingBudgetItems = true;
        draft.hasChanged = false;
        break;

      case GET_BUDGET_ITEMS_SUCCESS:
        draft.budgetItemList = action.payload.items;
        draft.budgetItemListTotal = action.payload.total;
        draft.isFetchingBudgetItems = false;
        break;

      case GET_BUDGET_ITEMS_ERROR:
        draft.isFetchingBudgetItems = false;
        break;

      case CLOSE_BUDGET_ITEM_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CLOSE_BUDGET_ITEM_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CLOSE_BUDGET_ITEM_ERROR:
        draft.isCommitting = false;
        break;

      case BUDGET_ITEMS_UNMOUNT:
        return initialState;
    }
  });
}
export default budgetItemReducer;
