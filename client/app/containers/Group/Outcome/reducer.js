/*
 *
 * Outcome reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_OUTCOMES_SUCCESS, GET_OUTCOME_SUCCESS,
  OUTCOMES_UNMOUNT
} from 'containers/Group/Outcome/constants';

export const initialState = {
  outcomes: [],
  outcomeTotal: null,
  currentOutcome: null,
};

/* eslint-disable default-case, no-param-reassign */
function outcomesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_OUTCOMES_SUCCESS:
        draft.outcomes = action.payload.items;
        draft.outcomeTotal = action.payload.total;
        break;
      case GET_OUTCOME_SUCCESS:
        draft.currentOutcome = action.payload.outcome;
        break;
      case OUTCOMES_UNMOUNT:
        return initialState;
    }
  });
}

export default outcomesReducer;
