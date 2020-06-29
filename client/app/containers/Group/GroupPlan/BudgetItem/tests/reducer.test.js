import produce from 'immer';
import {
  getBudgetItemsSuccess,
  getBudgetItemSuccess
} from 'containers/Group/GroupPlan/BudgetItem/actions';
import budgetItemReducer from 'containers/Group/GroupPlan/BudgetItem/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('budgetItemReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      budgetItemList: [],
      budgetItemListTotal: null,
      currentBudgetItem: null,
      isFetchingBudgetItems: true,
      isFetchingBudgetItem: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(budgetItemReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getBudgetItemsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.budgetItemList = { id: 4, name: 'dummy' };
      draft.budgetItemListTotal = 31;
      draft.isFetchingBudgetItems = false;
    });

    expect(
      budgetItemReducer(
        state,
        getBudgetItemsSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getBudgetItemSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentBudgetItem = { id: 4, name: 'dummy' };
      draft.isFetchingBudgetItem = false;
    });

    expect(
      budgetItemReducer(
        state,
        getBudgetItemSuccess({
          budget_item: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
