/*
 *
 * Custom Text reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_CUSTOM_TEXT_SUCCESS,
  CUSTOM_TEXT_UNMOUNT
} from 'containers/GlobalSettings/CustomText/constants';

export const initialState = {
  currentCustomText: null
};

function customTextReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_CUSTOM_TEXT_SUCCESS:
        draft.currentCustomText = action.payload.custom_text;
        break;
      case CUSTOM_TEXT_UNMOUNT:
        return initialState;
    }
  });
}

export default customTextReducer;
