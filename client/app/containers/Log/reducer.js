/*
 *
 * Log reducer
 *
 */

import produce from 'immer/dist/immer';

import {
  GET_LOGS_BEGIN,
  GET_LOGS_SUCCESS,
  GET_LOGS_ERROR,
  LOG_UNMOUNT,
} from 'containers/Log/constants';

export const initialState = {
  isLoading: true,
  logList: {},
  logTotal: null,
};

function logsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_LOGS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_LOGS_SUCCESS:
        draft.logList = formatLogs(action.payload.items);
        draft.logTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_LOGS_ERROR:
        draft.isLoading = false;
        break;
      case LOG_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatLogs(logs) {
  /* eslint-disable no-return-assign */

  /* Format segments to hash by id:
   *   { <id>: { name: segment_01, ... } }
   */
  return logs.reduce((map, log) => {
    map[log.id] = log;
    return map;
  }, {});
}

export default logsReducer;
