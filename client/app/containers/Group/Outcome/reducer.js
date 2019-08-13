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
};

/* eslint-disable default-case, no-param-reassign */
function outcomesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_OUTCOMES_SUCCESS:
        draft.outcomes = action.payload.items;
        break;
      case OUTCOMES_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatOutcomes(outcomes) {
  /* eslint-disable no-return-assign */

  /* Format outcomes to hash by id:
   *   { <id>: { name: outcome_01, ... } }
   */
  return outcomes.reduce((map, outcome) => {
    map[outcome.id] = outcome;
    return map;
  }, {});
}

export default outcomesReducer;
