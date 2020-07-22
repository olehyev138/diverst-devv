/*
 *
 * CsvFile reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  CREATE_CSV_FILE_BEGIN,
  CREATE_CSV_FILE_SUCCESS,
  CREATE_CSV_FILE_ERROR,
  CSV_FILES_UNMOUNT,
} from './constants';

export const initialState = {
  isCommitting: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function csvfileReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case CREATE_CSV_FILE_BEGIN:
        draft.isCommitting = true;
        break;

      case CREATE_CSV_FILE_SUCCESS:
        draft.isCommitting = false;
        break;

      case CREATE_CSV_FILE_ERROR:
        draft.isCommitting = false;
        break;

      case CSV_FILES_UNMOUNT:
        return initialState;
    }
  });
}
export default csvfileReducer;
