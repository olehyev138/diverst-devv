import produce from 'immer';
import {
  getExpensesSuccess,
  getExpenseSuccess
} from '../actions';
import expenseReducer from 'containers/Event/EventManage/Expense/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('expenseReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      expenseList: [],
      expenseListTotal: null,
      expenseListSum: null,
      currentExpense: null,
      isFetchingExpenses: true,
      isFetchingExpense: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(expenseReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getExpensesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.expenseList = { id: 4, name: 'dummy' };
      draft.expenseListTotal = 31;
      draft.expenseListSum = 9;
      draft.isFetchingExpenses = false;
    });

    expect(
      expenseReducer(
        state,
        getExpensesSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
          sum: 9
        })
      )
    ).toEqual(expected);
  });

  it('handles the getExpenseSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentExpense = { id: 4, name: 'dummy' };
      draft.isFetchingExpense = false;
    });

    expect(
      expenseReducer(
        state,
        getExpenseSuccess({
          initiative_expense: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
