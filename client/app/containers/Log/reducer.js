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
  EXPORT_LOGS_BEGIN,
  EXPORT_LOGS_SUCCESS,
  EXPORT_LOGS_ERROR,
} from 'containers/Log/constants';

export const initialState = {
  isLoading: true,
  logList: [],
  logTotal: null,
  isCommitting: false,
};

function logsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_LOGS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_LOGS_SUCCESS:
        draft.logList = action.payload.items;
        draft.logTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_LOGS_ERROR:
        draft.isLoading = false;
        break;
      case EXPORT_LOGS_BEGIN:
        draft.isCommitting = true;
        break;
      case EXPORT_LOGS_SUCCESS:
      case EXPORT_LOGS_ERROR:
        draft.isCommitting = false;
        break;
      case LOG_UNMOUNT:
        return initialState;
    }
  });
}

export default logsReducer;
