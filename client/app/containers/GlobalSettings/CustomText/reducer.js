/*
 *
 * Custom text reducer
 *
 */

import produce from 'immer';
import {
  UPDATE_CUSTOM_TEXT_BEGIN, UPDATE_CUSTOM_TEXT_SUCCESS,
  UPDATE_CUSTOM_TEXT_ERROR
} from 'containers/GlobalSettings/CustomText/constants';

export const initialState = {
  isCommitting: false,
};

/* eslint-disable default-case, no-param-reassign */
function customTextReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case UPDATE_CUSTOM_TEXT_BEGIN:
        draft.isCommitting = true;
        break;
      case UPDATE_CUSTOM_TEXT_SUCCESS:
      case UPDATE_CUSTOM_TEXT_ERROR:
        draft.isCommitting = false;
        break;
    }
  });
}

export default customTextReducer;
