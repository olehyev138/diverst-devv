import produce from 'immer/dist/immer';
import {
  GET_SSOSETTING_BEGIN, GET_SSOSETTING_ERROR,
  GET_SSOSETTING_SUCCESS, UPDATE_SSOSETTING_BEGIN,
  UPDATE_SSOSETTING_SUCCESS, UPDATE_SSOSETTING_ERROR, SSOSETTING_UNMOUNT,
} from 'containers/GlobalSettings/constants';

export const initialState = {
  isLoading: true,
  isCommitting: false,
  currentSSOSetting: null,
};

/* eslint-disable default-case, no-param-reassign */
function settingsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_SSOSETTING_ERROR:
        draft.isLoading = false;
        break;
      case GET_SSOSETTING_SUCCESS:
        draft.currentSSOSetting = action.payload.currentSSOSetting;
        draft.isLoading = false;
        break;
      case GET_SSOSETTING_BEGIN:
        draft.isLoading = true;
        break;
      case UPDATE_SSOSETTING_BEGIN:
        draft.isCommitting = true;
        break;
      case UPDATE_SSOSETTING_SUCCESS:
      case UPDATE_SSOSETTING_ERROR:
        draft.isCommitting = false;
        break;
      case SSOSETTING_UNMOUNT:
        return initialState;
    }
  });
}

export default settingsReducer;
