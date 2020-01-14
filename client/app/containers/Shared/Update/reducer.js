/*
 *
 * Update reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_UPDATE_BEGIN,
  GET_UPDATE_SUCCESS,
  GET_UPDATE_ERROR,
  GET_UPDATE_PROTOTYPE_BEGIN,
  GET_UPDATE_PROTOTYPE_SUCCESS,
  GET_UPDATE_PROTOTYPE_ERROR,
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
  UPDATES_UNMOUNT,
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
function updateReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_UPDATE_BEGIN:
      case GET_UPDATE_PROTOTYPE_BEGIN:
        draft.isFetchingUpdate = true;
        break;

      case GET_UPDATE_SUCCESS:
      case GET_UPDATE_PROTOTYPE_SUCCESS:
        draft.currentUpdate = formatUpdate(action.payload.update);
        draft.isFetchingUpdate = false;
        break;

      case GET_UPDATE_ERROR:
      case GET_UPDATE_PROTOTYPE_ERROR:
        draft.isFetchingUpdate = false;
        break;

      case GET_UPDATES_BEGIN:
        draft.isFetchingUpdates = true;
        draft.hasChanged = false;
        break;

      case GET_UPDATES_SUCCESS:
        draft.updateList = action.payload.items.map(formatUpdate);
        draft.updateListTotal = action.payload.total;
        draft.isFetchingUpdates = false;
        break;

      case GET_UPDATES_ERROR:
        draft.isFetchingUpdates = false;
        break;

      case DELETE_UPDATE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case DELETE_UPDATE_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case DELETE_UPDATE_ERROR:
        draft.isCommitting = false;
        break;

      case UPDATES_UNMOUNT:
        return initialState;
    }
  });
}
export default updateReducer;

const formatUpdate = (update) => {
  if (!update)
    return null;
  return produce(update, (uDraft) => {
    uDraft.field_data = update.field_data.map(fd => produce(fd, (draft) => {
      if (fd.data === null)
        draft.data = '';
    }));
  });
};
