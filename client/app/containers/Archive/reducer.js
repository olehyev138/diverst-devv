/*
 *
 * Archive reducer
 *
 */

import produce from 'immer';
import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR,
  RESTORE_ARCHIVE_BEGIN,
  RESTORE_ARCHIVE_SUCCESS,
  RESTORE_ARCHIVE_ERROR
} from './constants';
import eventsReducer from '../Event/reducer';


export const initialState = {
  isCommitting: false,
  isLoading: true,
  archives: null,
  archivesTotal: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function archivesReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_ARCHIVES_BEGIN:
        draft.isLoading = true;
        draft.hasChanged = false;
        break;
      case RESTORE_ARCHIVE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case GET_ARCHIVES_SUCCESS:
        draft.isCommitting = false;
        draft.isLoading = false;
        draft.archives = action.payload.items;
        draft.archivesTotal = action.payload.total;
        break;
      case RESTORE_ARCHIVE_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;
      case GET_ARCHIVES_ERROR:
      case RESTORE_ARCHIVE_ERROR:
        draft.isLoading = false;
        draft.isCommitting = false;
        break;
    }
  });
}
export default archivesReducer;
