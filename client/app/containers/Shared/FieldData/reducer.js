/*
 *
 * FieldData reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  UPDATE_FIELD_DATA_BEGIN,
  UPDATE_FIELD_DATA_SUCCESS,
  UPDATE_FIELD_DATA_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function fieldDataReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case UPDATE_FIELD_DATA_BEGIN:
        draft.isCommitting = true;
        break;

      case UPDATE_FIELD_DATA_ERROR:
      case UPDATE_FIELD_DATA_SUCCESS:
        draft.isCommitting = false;
        break;
    }
  });
}
export default fieldDataReducer;
