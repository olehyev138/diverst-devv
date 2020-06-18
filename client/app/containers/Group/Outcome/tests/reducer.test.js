import produce from 'immer';
import {
  getOutcomesSuccess,
  getOutcomeSuccess
} from 'containers/Group/Outcome/actions';
import outcomeReducer from 'containers/Group/Outcome/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('outcomeReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isFormLoading: true,
      isCommitting: false,
      outcomes: [],
      outcomesTotal: null,
      currentOutcome: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(outcomeReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getOutcomesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.outcomes = { id: 4, name: 'dummy' };
      draft.outcomesTotal = 31;
      draft.isLoading = false;
    });

    expect(
      outcomeReducer(
        state,
        getOutcomesSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getOutcomeSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentOutcome = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      outcomeReducer(
        state,
        getOutcomeSuccess({
          outcome: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
