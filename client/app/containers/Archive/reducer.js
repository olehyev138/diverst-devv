/*
 *
 * Archive reducer
 *
 */

import produce from 'immer';
import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR
} from "./constants";


export const initialState = {
  isCommitting: false,
  isLoading: true,
  archives: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function resourcesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_ARCHIVES_BEGIN:
        draft.isLoading = true;
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case GET_ARCHIVES_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;
      case GET_ARCHIVES_ERROR:
        draft.isLoading = false;
        draft.isCommitting = false;
        break;
    }
  });
}
