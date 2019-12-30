/*
 *
 * Kpi reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_UPDATE_BEGIN,
  GET_UPDATE_SUCCESS,
  GET_UPDATE_ERROR,
  GET_UPDATES_BEGIN,
  GET_UPDATES_SUCCESS,
  GET_UPDATES_ERROR,
  CREATE_UPDATE_BEGIN,
  CREATE_UPDATE_SUCCESS,
  CREATE_UPDATE_ERROR,
  UPDATE_UPDATE_BEGIN,
  UPDATE_UPDATE_SUCCESS,
  UPDATE_UPDATE_ERROR,
  DELETE_UPDATE_BEGIN,
  DELETE_UPDATE_SUCCESS,
  DELETE_UPDATE_ERROR,
  FIELDS_UNMOUNT,
} from './constants';

export const initialState = {
  updateList: [],
  updateListTotal: null,
  currentUpdate: null,
  isFetchingUpdates: false,
  isFetchingUpdate: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function kpiReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_UPDATE_BEGIN:
        draft.isFetchingUpdate = true;
        break;

      case GET_UPDATE_SUCCESS:
        draft.currentUpdate = action.payload.kpi;
        draft.isFetchingUpdate = false;
        break;

      case GET_UPDATE_ERROR:
        draft.isFetchingUpdate = false;
        break;

      case GET_UPDATES_BEGIN:
        draft.isFetchingUpdates = true;
        draft.hasChanged = false;
        break;

      case GET_UPDATES_SUCCESS:
        draft.updateList = action.payload.items;
        draft.updateListTotal = action.payload.total;
        draft.isFetchingUpdates = false;
        break;

      case GET_UPDATES_ERROR:
        draft.isFetchingUpdates = false;
        break;

      case CREATE_UPDATE_BEGIN:
      case UPDATE_UPDATE_BEGIN:
      case DELETE_UPDATE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_UPDATE_SUCCESS:
      case UPDATE_UPDATE_SUCCESS:
      case DELETE_UPDATE_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_UPDATE_ERROR:
      case UPDATE_UPDATE_ERROR:
      case DELETE_UPDATE_ERROR:
        draft.isCommitting = false;
        break;

      case FIELDS_UNMOUNT:
        return initialState;
    }
  });
}
export default kpiReducer;
