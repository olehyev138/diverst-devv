import produce from 'immer';
import annualBudgetReducer from '../reducer';
import {
  getCurrentAnnualBudgetSuccess, getCurrentAnnualBudgetError, getCurrentAnnualBudgetBegin,
  getAnnualBudgetSuccess, getAnnualBudgetError, getAnnualBudgetBegin,
  getAnnualBudgetsSuccess, getAnnualBudgetsError, getAnnualBudgetsBegin,
  createAnnualBudgetSuccess, createAnnualBudgetError, createAnnualBudgetBegin,
  updateAnnualBudgetSuccess, updateAnnualBudgetError, updateAnnualBudgetBegin,
  annualBudgetsUnmount
} from '../actions';
import { getEventsBegin, getEventsSuccess, getEventsError } from 'containers/Event/actions';


/* eslint-disable default-case, no-param-reassign */
describe('annualBudgetReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      annualBudgetList: [],
      annualBudgetListTotal: null,
      annualBudgetInitiativeList: {},
      annualBudgetInitiativeListTotal: {},
      isFetchingAnnualBudgetInitiatives: {},
      currentAnnualBudget: null,
      isFetchingAnnualBudgets: true,
      isFetchingAnnualBudget: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(annualBudgetReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getCurrentAnnualBudgetBegin, getAnnualBudgetBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudget = true;
    });

    expect(
      annualBudgetReducer(
        state,
        getCurrentAnnualBudgetBegin({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetBegin({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the getCurrentAnnualBudgetSuccess, getAnnualBudgetSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentAnnualBudget = { id: 37, name: 'dummy' };
      draft.isFetchingAnnualBudget = false;
    });

    expect(
      annualBudgetReducer(
        state,
        getCurrentAnnualBudgetSuccess({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetSuccess({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the getCurrentAnnualBudgetError, getAnnualBudgetError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudget = false;
    });

    expect(
      annualBudgetReducer(
        state,
        getCurrentAnnualBudgetError({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetError({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the getAnnualBudgetsBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudgets = true;
      draft.hasChanged = false;
    });

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetsBegin({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the getAnnualBudgetsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.annualBudgetList = [{ id: 5, name: 'dummy' }];
      draft.annualBudgetListTotal = 9;
      draft.isFetchingAnnualBudgets = false;
    });

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetsSuccess({
          items: [{
            id: 5,
            name: 'dummy'
          }],
          total: 9
        })
      )
    ).toEqual(expected);
  });

  it('handles the getAnnualBudgetsError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudgets = false;
    });

    expect(
      annualBudgetReducer(
        state,
        getAnnualBudgetsError({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the createAnnualBudgetBegin, updateAnnualBudgetBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
      draft.hasChanged = false;
    });

    expect(
      annualBudgetReducer(
        state,
        createAnnualBudgetBegin({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        updateAnnualBudgetBegin({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the createAnnualBudgetSuccess, updateAnnualBudgetSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.hasChanged = true;
    });

    expect(
      annualBudgetReducer(
        state,
        createAnnualBudgetSuccess({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        updateAnnualBudgetSuccess({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the createAnnualBudgetError, updateAnnualBudgetError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      annualBudgetReducer(
        state,
        createAnnualBudgetError({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);

    expect(
      annualBudgetReducer(
        state,
        updateAnnualBudgetError({ annual_budget: {
          id: 37,
          name: 'dummy'
        } })
      )
    ).toEqual(expected);
  });

  it('handles the getEventsBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudgetInitiatives = { 5: true };
    });

    expect(
      annualBudgetReducer(
        state,
        getEventsBegin({ annualBudgetId: 5 })
      )
    ).toEqual(expected);
  });

  it('handles the getEventsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.annualBudgetInitiativeList = { 2: [{ id: 5, name: 'dummy' }] };
      draft.isFetchingAnnualBudgetInitiatives = { 2: false };
      draft.annualBudgetInitiativeListTotal = { 2: 9 };
    });

    expect(
      annualBudgetReducer(
        state,
        getEventsSuccess({
          items: [{
            id: 5,
            name: 'dummy'
          }],
          total: 9,
          annualBudgetId: 2,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getEventsError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingAnnualBudgetInitiatives = { 37: false };
    });

    expect(
      annualBudgetReducer(
        state,
        getEventsError({ annualBudgetId: 37 })
      )
    ).toEqual(expected);
  });

  it('handles the metricsUnmount action correctly', () => {
    const expected = state;

    expect(annualBudgetReducer(state, annualBudgetsUnmount())).toEqual(expected);
  });
});
