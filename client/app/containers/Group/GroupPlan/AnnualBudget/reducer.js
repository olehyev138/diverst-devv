/*
 *
 * AnnualBudget reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_CURRENT_ANNUAL_BUDGET_BEGIN,
  GET_CURRENT_ANNUAL_BUDGET_SUCCESS,
  GET_CURRENT_ANNUAL_BUDGET_ERROR,
  GET_ANNUAL_BUDGET_BEGIN,
  GET_ANNUAL_BUDGET_SUCCESS,
  GET_ANNUAL_BUDGET_ERROR,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_ANNUAL_BUDGETS_SUCCESS,
  GET_ANNUAL_BUDGETS_ERROR,
  CREATE_ANNUAL_BUDGET_BEGIN,
  CREATE_ANNUAL_BUDGET_SUCCESS,
  CREATE_ANNUAL_BUDGET_ERROR,
  UPDATE_ANNUAL_BUDGET_BEGIN,
  UPDATE_ANNUAL_BUDGET_SUCCESS,
  UPDATE_ANNUAL_BUDGET_ERROR,
  ANNUAL_BUDGETS_UNMOUNT,
} from './constants';

import {
  GET_EVENTS_SUCCESS
} from 'containers/Event/constants';

export const initialState = {
  annualBudgetList: [],
  annualBudgetListTotal: null,
  annualBudgetInitiativeList: {},
  annualBudgetInitiativeListTotal: {},
  currentAnnualBudget: null,
  isFetchingAnnualBudgets: false,
  isFetchingAnnualBudget: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function annualBudgetReducer(state = initialState, action) {
  let annualBudgetId;
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_CURRENT_ANNUAL_BUDGET_BEGIN:
      case GET_ANNUAL_BUDGET_BEGIN:
        draft.isFetchingAnnualBudget = true;
        break;

      case GET_CURRENT_ANNUAL_BUDGET_SUCCESS:
      case GET_ANNUAL_BUDGET_SUCCESS:
        draft.currentAnnualBudget = action.payload.annual_budget;
        draft.isFetchingAnnualBudget = false;
        break;

      case GET_CURRENT_ANNUAL_BUDGET_ERROR:
      case GET_ANNUAL_BUDGET_ERROR:
        draft.isFetchingAnnualBudget = false;
        break;

      case GET_ANNUAL_BUDGETS_BEGIN:
        draft.isFetchingAnnualBudgets = true;
        draft.hasChanged = false;
        break;

      case GET_ANNUAL_BUDGETS_SUCCESS:
        draft.annualBudgetList = action.payload.items;
        draft.annualBudgetListTotal = action.payload.total;
        draft.isFetchingAnnualBudgets = false;
        break;

      case GET_ANNUAL_BUDGETS_ERROR:
        draft.isFetchingAnnualBudgets = false;
        break;

      case CREATE_ANNUAL_BUDGET_BEGIN:
      case UPDATE_ANNUAL_BUDGET_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_ANNUAL_BUDGET_SUCCESS:
      case UPDATE_ANNUAL_BUDGET_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_ANNUAL_BUDGET_ERROR:
      case UPDATE_ANNUAL_BUDGET_ERROR:
        draft.isCommitting = false;
        break;

      case GET_EVENTS_SUCCESS:
        annualBudgetId = action.payload.items ? action.payload.items[0].annual_budget_id : null;
        if (annualBudgetId) {
          draft.annualBudgetInitiativeList = produce(draft.annualBudgetInitiativeList, (draft2) => {
            draft2[annualBudgetId] = action.payload.items;
          });
          draft.annualBudgetInitiativeListTotal = produce(draft.annualBudgetInitiativeList, (draft2) => {
            draft2[annualBudgetId] = action.payload.total;
          });
        }
        break;

      case ANNUAL_BUDGETS_UNMOUNT:
        return initialState;
    }
  });
}
export default annualBudgetReducer;
