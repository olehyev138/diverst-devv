/*
 *
 * Outcome reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_OUTCOMES_SUCCESS, GET_OUTCOME_SUCCESS, GET_OUTCOMES_BEGIN,
  OUTCOMES_UNMOUNT, GET_OUTCOMES_ERROR, GET_OUTCOME_ERROR
} from 'containers/Group/Outcome/constants';

export const initialState = {
  isLoading: true,
  outcomes: [],
  outcomeTotal: null,
  currentOutcome: null,
};

/* eslint-disable default-case, no-param-reassign */
function outcomesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_OUTCOMES_BEGIN:
        draft.isLoading = true;
        break;
      case GET_OUTCOMES_SUCCESS:
        draft.outcomes = action.payload.items;
        draft.outcomeTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_OUTCOMES_ERROR:
        draft.isLoading = false;
        break;
      case GET_OUTCOME_SUCCESS:
        draft.currentOutcome = action.payload.outcome;
        draft.isLoading = false;
        break;
      case GET_OUTCOME_ERROR:
        draft.isLoading = false;
        break;
      case OUTCOMES_UNMOUNT:
        return initialState;
    }
  });
}

export default outcomesReducer;
