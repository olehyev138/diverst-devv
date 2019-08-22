/*
 *
 * Metrics reducer
 *
 */

import produce from 'immer';
import {
  GET_GROUP_POPULATION_SUCCESS,
  METRICS_UNMOUNT
} from 'containers/Analyze/constants';

export const initialState = {
  metricsData: {
    groupPopulation: {}
  }
};

/* eslint-disable default-case, no-param-reassign */
function metricsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUP_POPULATION_SUCCESS:
        draft.metricsData.groupPopulation = action.payload.data;
        break;
      case METRICS_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

export default metricsReducer;
