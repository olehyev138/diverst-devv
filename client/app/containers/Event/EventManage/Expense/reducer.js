/*
 *
 * Expense reducer
 *
 */

import produce from 'immer/dist/immer';
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

export const initialState = {
  expenseList: [],
  expenseListTotal: null,
  currentExpense: null,
  isFetchingExpenses: false,
  isFetchingExpense: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function expenseReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_EXPENSE_BEGIN:
        draft.isFetchingExpense = true;
        break;

      case GET_EXPENSE_SUCCESS:
        draft.currentExpense = action.payload.expense;
        draft.isFetchingExpense = false;
        break;

      case GET_EXPENSE_ERROR:
        draft.isFetchingExpense = false;
        break;

      case GET_EXPENSES_BEGIN:
        draft.isFetchingExpenses = true;
        draft.hasChanged = false;
        break;

      case GET_EXPENSES_SUCCESS:
        draft.expenseList = action.payload.items;
        draft.expenseListTotal = action.payload.total;
        draft.isFetchingExpenses = false;
        break;

      case GET_EXPENSES_ERROR:
        draft.isFetchingExpenses = false;
        break;

      case CREATE_EXPENSE_BEGIN:
      case UPDATE_EXPENSE_BEGIN:
      case DELETE_EXPENSE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_EXPENSE_SUCCESS:
      case UPDATE_EXPENSE_SUCCESS:
      case DELETE_EXPENSE_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_EXPENSE_ERROR:
      case UPDATE_EXPENSE_ERROR:
      case DELETE_EXPENSE_ERROR:
        draft.isCommitting = false;
        break;

      case EXPENSES_UNMOUNT:
        return initialState;
    }
  });
}
export default expenseReducer;
