/*
 *
 * Outcome reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_OUTCOMES_SUCCESS, GET_OUTCOME_SUCCESS, GET_OUTCOMES_BEGIN,
  OUTCOMES_UNMOUNT, GET_OUTCOMES_ERROR, GET_OUTCOME_ERROR,
  CREATE_OUTCOME_BEGIN, CREATE_OUTCOME_SUCCESS, CREATE_OUTCOME_ERROR,
  UPDATE_OUTCOME_BEGIN, UPDATE_OUTCOME_SUCCESS, UPDATE_OUTCOME_ERROR, GET_OUTCOME_BEGIN,
} from 'containers/Group/Outcome/constants';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  outcomes: [],
  outcomesTotal: null,
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
        draft.outcomesTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_OUTCOMES_ERROR:
        draft.isLoading = false;
        break;
      case GET_OUTCOME_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_OUTCOME_SUCCESS:
        draft.currentOutcome = action.payload.outcome;
        draft.isFormLoading = false;
        break;
      case GET_OUTCOME_ERROR:
        draft.isFormLoading = false;
        break;
      case CREATE_OUTCOME_BEGIN:
      case UPDATE_OUTCOME_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_OUTCOME_SUCCESS:
      case UPDATE_OUTCOME_SUCCESS:
      case CREATE_OUTCOME_ERROR:
      case UPDATE_OUTCOME_ERROR:
        draft.isCommitting = false;
        break;
      case OUTCOMES_UNMOUNT:
        return initialState;
    }
  });
}

export default outcomesReducer;
